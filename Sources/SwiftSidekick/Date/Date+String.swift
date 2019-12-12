//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public extension Date {
    var string: String { string(for: .storage) }
    func string(for format: StringFormats) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.value
        return formatter.string(from: self)
    }
}
public extension Date {
    enum StringFormats: String {
        case storage = "yyyy-MM-dd HH:mm:ss.SSS ZZZZZ"
    }
}
public extension Date.StringFormats {
    var value: String { rawValue }
}
