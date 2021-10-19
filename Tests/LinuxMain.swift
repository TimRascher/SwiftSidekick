//
//  Created by Timothy Rascher on 12/12/19.
//

import XCTest

import SwiftSidekickTests

var tests = [XCTestCaseEntry]()
tests += FileManagerTests.allTests()
tests += DateTests.allTests()
XCTMain(tests)
