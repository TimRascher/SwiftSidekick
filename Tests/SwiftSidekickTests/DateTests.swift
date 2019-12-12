//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import XCTest
@testable import SwiftSidekick

final class DateTests: XCTestCase {
    static var allTests = [
        ("testDateToString", testDateToString),
        ("testStringToDate", testStringToDate),
    ]

    private let dateString = "1983-11-10 20:09:09.009 -08:00"
    lazy private var testDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS ZZZZZ"
        return formatter.date(from: dateString)!
    }()
}
extension DateTests {
    func testDateToString() {
        let date = testDate
        let string = date.string
        XCTAssert(string == dateString, "Dates do not match!")
    }
    func testStringToDate() {
        guard let date = dateString.date else {
            XCTAssert(false, "Date was nil")
            return
        }
        XCTAssert(date == testDate, "Dates do not match!")
    }
}
