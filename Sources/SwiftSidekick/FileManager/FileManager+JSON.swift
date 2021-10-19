//
//  Created by Timothy Rascher on 12/12/19.
//

import Foundation

public extension FileManager {
    func write<T: Encodable>(_ object: T, to path: String, in pathDirectory: PathDirectories? = nil) throws {
        let url = try createURL(from: path, and: pathDirectory)
        try write(object, to: url)
    }
    func write<T: Encodable>(_ object: T, to url: URL) throws {
        let data = try JSONEncoder().encode(object)
        try write(data, to: url)
    }
}
public extension FileManager {
    func readObject<T: Decodable>(_ type: T.Type = T.self, from path: String, in pathDirectory: PathDirectories? = nil) throws -> T {
        let url = try createURL(from: path, and: pathDirectory)
        return try readObject(from: url)
    }
    func readObject<T: Decodable>(_ type: T.Type = T.self, from url: URL) throws -> T {
        let data = try read(from: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
