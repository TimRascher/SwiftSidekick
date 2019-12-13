//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public extension Date {
    var string: String { string(for: .storage) }
    func string(for format: StringFormats, with part: StringParts = .all) -> String {
        var part = part
        let formatter = DateFormatter()
        if format.dateIsAll { part = .date }
        switch part {
        case .all: formatter.dateFormat = format.all
        case .date: formatter.dateFormat = format.date
        case .time: formatter.dateFormat = format.time
        }
        return formatter.string(from: self)
    }
}
public extension Date {
    struct StringFormats {
        public var all: String {
            if dateIsAll {
                return date
            }
            return "\(date) \(time)"
        }
        public let date: String
        public let time: String
        fileprivate let dateIsAll: Bool
        
        public init(value: String) {
            dateIsAll = true
            self.date = value
            self.time = ""
        }
        public init(date: String, time: String) {
            dateIsAll = false
            self.date = date
            self.time = time
        }
    }
    enum StringParts {
        case all
        case date
        case time
    }
}
public extension Date.StringFormats {
    static var storage: Date.StringFormats { Date.StringFormats(date: "yyyy-MM-dd", time: "HH:mm:ss.SSS ZZZZZ") }
    static var short: Date.StringFormats { Date.StringFormats(date: "M/d/yy", time: "h:mm a") }
    static var medium: Date.StringFormats { Date.StringFormats(date: "MMM dd, yyyy", time: "h:mm:ss a") }
    static var long: Date.StringFormats { Date.StringFormats(date: "MMMM dd, yyyy", time: "hh:mm:ss a zzz") }
    static var full: Date.StringFormats { Date.StringFormats(date: "EEEE, MMMM dd, yyyy", time: "hh:mm:ss a zzzz") }
}
