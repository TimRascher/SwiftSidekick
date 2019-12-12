//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import XCTest

import SwiftSidekickTests

var tests = [XCTestCaseEntry]()
tests += FileManagerTests.allTests()
tests += DateTests.allTests()
XCTMain(tests)
