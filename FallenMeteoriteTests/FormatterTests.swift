//
//  FormatterTests.swift
//  FallenMeteoriteTests
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import XCTest
import MapKit
@testable import FallenMeteorite

class FormatterTests: XCTestCase {

    func testYearFromJson() {

        let jsonString = "2011-01-01T00:00:000"
        let formattedYear = Formatter.yearFromJson(jsonString)

        XCTAssertEqual(formattedYear, "2011")
    }

    func testYearFromShortString() {

        let jsonString = "20"
        let formattedYear = Formatter.yearFromJson(jsonString)

        XCTAssertEqual(formattedYear, "20")
    }

    func testYearFromShortEmptyString() {

        let jsonString = ""
        let formattedYear = Formatter.yearFromJson(jsonString)

        XCTAssertEqual(formattedYear, "")
    }

    func testDoubleToString() {

        XCTAssertEqual(Formatter.doubleToString(233.212421), "233,212421")
    }

    func testDoubleToStringWithMaxFractionDigits() {

        XCTAssertEqual(Formatter.doubleToString(233.212421, maxFractionDigits: 2), "233,21")
    }
}
