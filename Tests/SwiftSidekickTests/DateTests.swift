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
        ("testCustomFormat", testCustomFormat),
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
    func testCustomFormat() {
        let string = testDate.string(for: .niceShort)
        XCTAssert(string == "Nov 10, 8:09 PM", "Date did not format correctly!")
    }
    func testFormats() {
        func check(_ date: Date, _ format: Date.StringFormats, dateString: String, timeString: String) {
            let stringFull = testDate.string(for: format)
            let stringDate = testDate.string(for: format, with: .date)
            let stringTime = testDate.string(for: format, with: .time)
            XCTAssert(stringFull == "\(dateString) \(timeString)", "\(format) Full date incorrect.")
            XCTAssert(stringDate == dateString, "\(format) Date date incorrect.")
            XCTAssert(stringTime == timeString, "\(format) Time date incorrect.")
        }
        check(testDate, .storage, dateString: "1983-11-10", timeString: "20:09:09.009 -08:00")
        check(testDate, .short, dateString: "11/10/83", timeString: "8:09 PM")
        check(testDate, .medium, dateString: "Nov 10, 1983", timeString: "8:09:09 PM")
        check(testDate, .long, dateString: "November 10, 1983", timeString: "08:09:09 PM PST")
        check(testDate, .full, dateString: "Thursday, November 10, 1983", timeString: "08:09:09 PM Pacific Standard Time")
    }
}
private extension DateTests {
}

private extension Date.StringFormats {
    static var niceShort: Date.StringFormats { .init(value: "MMM d, h:mm a") }
}
