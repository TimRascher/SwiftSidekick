//
//  File.swift
//  
//
//  Created by Timothy Rascher on 11/17/22.
//

import Foundation

open class Keychain {
    // MARK: - Type Alias
    private typealias Query = [String: AnyObject]
    
    // MARK: - Subscripts
    open subscript(key: String) -> String? {
        get { return item(key) }
        set(value) {
            if item(key) != nil { removeItem(key) }
            if let value = value {
                let query = newItem(key, value)
                saveItem(query)
            }
        }
    }
    
    // MARK: - Methods
    private func data(_ string: String) -> Data { string.data(using: .utf8)! }
    private func basicQuery(_ key: String, _ forReturn: Bool) -> Query {
        var query = Query()
        query[kSecClass as String] = kSecClassGenericPassword as AnyObject?
        query[kSecAttrAccount as String] = data(key) as AnyObject?
        query[kSecAttrService as String] = data(key) as AnyObject?
        if forReturn {
            query[kSecMatchLimit as String] = kSecMatchLimitOne as AnyObject?
            query[kSecReturnAttributes as String] = kCFBooleanTrue as AnyObject?
        }
        return query
    }
    private func item(_ key: String) -> String? {
        let query = basicQuery(key, true)
        guard var secondQuery = fromKeychain(query) as? [String: AnyObject] else { return nil }
        secondQuery[kSecClass as String] = kSecClassGenericPassword as AnyObject?
        secondQuery[kSecReturnData as String] = kCFBooleanTrue as AnyObject?
        if let data = fromKeychain(secondQuery) as? Data {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
    private func fromKeychain(_ query: Query) -> AnyObject? {
        var results: AnyObject?
        let status = withUnsafeMutablePointer(to: &results) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == noErr { return results }
        return nil
    }
    private func newItem(_ key: String, _ value: String) -> Query {
        var query = basicQuery(key, false)
        query[kSecValueData as String] = data(value) as AnyObject?
        return query
    }
    @discardableResult
    private func removeItem(_ key: String) -> Bool {
        let query = basicQuery(key, false)
        let status = SecItemDelete(query as CFDictionary)
        if status == noErr { return true }
        return false
    }
    @discardableResult
    private func saveItem(_ items: Query) -> Bool {
        let status = SecItemAdd(items as CFDictionary, nil)
        if status == noErr { return true }
        return false
    }
    
    // MARK: - Singleton
    public static var main = Keychain()
}
