//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import XCTest
@testable import SwiftSidekick

final class FileManagerTests: XCTestCase {
    static var allTests = [
        ("testJSONReadWrite", testJSONReadWrite),
        ("testFileExsists", testFileExsists),
        ("testDirectoryExsists", testDirectoryExsists),
        ("testNothingExsists", testNothingExsists),
        ("testDirectoryURL", testURLCreation),
        ("testWriteData", testReadWriteData),
        ("testJSONReadWrite", testJSONReadWrite),
    ]
}
// MARK: - FileManager+Directories
extension FileManagerTests {
    func testFileExsists() {
        let manager = FileManager.default
        do {
            let url = try manager.createURL(from: "FileManager/file.txt", and: .applicationSupportDirectory)
            try manager.write("Test", to: url)
            let exsistance = manager.exsists(at: url)
            XCTAssert(exsistance == .isFile, "File was not there.")
            try manager.removeItem(at: url)
        } catch {
            XCTAssert(false, "\(error) was thrown")
        }
    }
    func testDirectoryExsists() {
        let manager = FileManager.default
        do {
            let url = try manager.createURL(from: "FileManager", and: .applicationSupportDirectory)
            try manager.createDirectory(from: url)
            let exsistance = manager.exsists(at: url)
            XCTAssert(exsistance == .isDirectory, "Directory was not there.")
            try manager.removeItem(at: url)
        } catch {
            XCTAssert(false, "\(error) was thrown")
        }
    }
    func testNothingExsists() {
        let manager = FileManager.default
        do {
            let url = try manager.createURL(from: "FileManager/\(UUID().uuidString).txt", and: .applicationSupportDirectory)
            let exsistance = manager.exsists(at: url)
            XCTAssert(exsistance == .doesNotExsist, "\(url.absoluteURL) exsits!")
        } catch {
            XCTAssert(false, "\(error) was thrown")
        }
    }
}
// MARK: - FileManager+JSON
extension FileManagerTests {
    func testJSONReadWrite() {
        let object = TestStruct()
        let manager = FileManager.default
        do {
            let url = try manager.createURL(from: "text.json", and: .applicationSupportDirectory)
            try manager.write(object, to: url)
            let readObject: TestStruct = try manager.readObject(from: url)
            XCTAssert(readObject == object, "Object do not match!")
            try manager.removeItem(at: url)
        } catch {
            XCTAssert(false, "\(error) was thrown")
        }
    }
    private struct TestStruct: Codable, Equatable {
        var id = UUID().uuidString
        var title = "This is a test object"
    }
}
// MARK: - FileManager+ReadWrite
extension FileManagerTests {
    func testURLCreation() {
        let url = try? FileManager.default.createURL(from: "FileManagerTests/text.txt", and: .applicationSupportDirectory)
        let path = url?.absoluteString
        XCTAssert(path != nil, "Path Should Exsist")
        XCTAssert(path?.hasSuffix("Application%20Support/FileManagerTests/text.txt") == true, "Path should end with 'Application%20Support/FileManagerTests/text.txt'")
    }
    func testReadWriteData() {
        let content = "This is some test content to write, and then read back."
        let manager = FileManager.default
        do {
            try manager.write(content, to: "TestDir/TestFile.txt", in: .applicationSupportDirectory)
            let readContent = try manager.readString(from: "TestDir/TestFile.txt", in: .applicationSupportDirectory)
            XCTAssert(readContent == content, "Contents do not match!")
            let url = try manager.createURL(from: "TestDir/TestFile.txt", and: .applicationSupportDirectory)
            try manager.removeItem(at: url)
            try manager.removeItem(at: url.deletingLastPathComponent())
        } catch {
            XCTAssert(false, "\(error) was thrown")
        }
    }
}
