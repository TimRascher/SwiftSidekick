//
//  Created by Timothy Rascher on 12/12/19.
//

import Foundation

public extension FileManager {
    func write(_ string: String, to path: String, in pathDirectory: PathDirectories? = nil) throws {
        try write(try data(from: string), to: path, in: pathDirectory)
    }
    func write(_ string: String, to url: URL) throws {
        try write(try data(from: string), to: url)
    }
    func write(_ data: Data, to path: String, in pathDirectory: PathDirectories? = nil) throws {
        let url = try createURL(from: path, and: pathDirectory)
        try write(data, to: url)
    }
    func write(_ data: Data, to url: URL) throws {
        try createDirectory(from: url.deletingLastPathComponent())
        try data.write(to: url, options: [.atomicWrite])
    }
}
public extension FileManager {
    func readString(from path: String, in pathDirectory: PathDirectories? = nil) throws -> String {
        let url = try createURL(from: path, and: pathDirectory)
        return try readString(from: url)
    }
    func readString(from url: URL) throws -> String {
        let data = try read(from: url)
        guard let string = String(data: data, encoding: .utf8) else {
            throw ReadErrors.couldNotConvertToString(data)
        }
        return string
    }
    func read(from path: String, in pathDirectory: PathDirectories? = nil) throws -> Data {
        let url = try createURL(from: path, and: pathDirectory)
        return try read(from: url)
    }
    func read(from url: URL) throws -> Data {
        let data = try Data(contentsOf: url)
        return data
    }
}
public extension FileManager {
    func createURL(from path: String, and pathDirectory: PathDirectories?) throws -> URL {
        if let pathDirectory = pathDirectory {
            guard let url = pathDirectory.url else { throw URLErrors.couldNotCreateURL(path, pathDirectory) }
            return url.appendingPathComponent(path)
        }
        guard let url = URL(string: path) else { throw URLErrors.couldNotCreateURL(path, pathDirectory) }
        return url
    }
    func createDirectory(from url: URL) throws {
        switch exsists(at: url) {
        case .isDirectory: return
        case .isFile:
            try removeItem(at: url)
            fallthrough
        case .doesNotExsist:
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
extension FileManager {
    func data(from string: String) throws -> Data {
        guard let data = string.data(using: .utf8) else { throw WriteErrors.couldNotConvertToData(string) }
        return data
    }
}
public extension FileManager {
    enum URLErrors: Error {
        case couldNotCreateURL(String, PathDirectories?)
    }
}
public extension FileManager {
    enum WriteErrors: Error {
        case couldNotConvertToData(String)
    }
}
public extension FileManager {
    enum ReadErrors: Error {
        case couldNotConvertToString(Data)
    }
}
