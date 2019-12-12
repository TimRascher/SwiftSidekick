//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public typealias PathDirectories = FileManager.SearchPathDirectory

public extension FileManager {
    enum FileState {
        case doesNotExsist
        case isFile
        case isDirectory
    }
    func exsists(at url: URL) -> FileState {
        return exsists(at: url.path)
    }
    func exsists(at path: String) -> FileState {
        var isDirectory: ObjCBool = false
        let doesExsist = fileExists(atPath: path, isDirectory: &isDirectory)
        switch (doesExsist, isDirectory.boolValue) {
        case (false, _): return .doesNotExsist
        case (true, false): return .isFile
        case (true, true): return .isDirectory
        }
    }
}

public extension FileManager.SearchPathDirectory {
    var url: URL? { FileManager.default.urls(for: self, in: .userDomainMask).first }
}
