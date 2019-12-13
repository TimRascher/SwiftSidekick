//
//  Created by Timothy Rascher on 12/13/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public extension Date {
    static func + (lhs: Date, rhs: Components) throws -> Date {
        let calendar = Calendar.autoupdatingCurrent
        guard let newDate = calendar.date(byAdding: rhs.calendarComponent, value: rhs.value, to: lhs) else {
            throw MathErrors.unableToAdd(lhs, rhs)
        }
        return newDate
    }
    static func - (lhs: Date, rhs: Components) throws -> Date {
        return try lhs + rhs.new(value: rhs.value * -1)
    }
}
public extension Date {
    enum MathErrors: Error {
        case unableToAdd(Date, Components)
    }
}
public extension Date {
    enum Components {
        case year(Int)
        case month(Int)
        case day(Int)
        case hour(Int)
        case minute(Int)
        case second(Int)
    }
}
extension Date.Components {
    var value: Int {
        switch self {
        case .year(let value), .month(let value),
             .day(let value), .hour(let value), .minute(let value),
             .second(let value): return value
        }
    }
    var calendarComponent: Calendar.Component {
        switch self {
        case .year: return .year
        case .month: return .month
        case .day: return .day
        case .hour: return .hour
        case .minute: return .minute
        case .second: return .second
        }
    }
}
private extension Date.Components {
    func new(value: Int) -> Date.Components {
        switch self {
        case .year: return .year(value)
        case .month: return .month(value)
        case .day: return .day(value)
        case .hour: return .hour(value)
        case .minute: return .minute(value)
        case .second: return .second(value)
        }
    }
}
