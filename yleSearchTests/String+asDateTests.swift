//
//  String+asDateTests.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/10/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import XCTest
@testable import yleSearch

class String_asDateTests: XCTestCase {
    
    func test_unitTesting_worksCorrect() {
        XCTAssertTrue(true)
    }
    
    func test_String_asDate_returnExpectedSeconds() {
        for second in 0...59 {
            // Arrange
            let rawDateString = "1970-01-01T00:00:\(second).000+00:00"
            let expectedDate = Date(timeIntervalSince1970: Double(second))
            // Act
            let resultDate = rawDateString.asDate
            // Assert
            XCTAssertEqual(resultDate, expectedDate)
        }
    }
    
    func test_String_asDate_returnExpectedMinutes() {
        for minute in 0...59 {
            // Arrange
            let rawDateString = "1970-01-01T00:\(minute):00.000+00:00"
            let expectedDate = Date(timeIntervalSince1970: Double(60*minute))
            // Act
            let resultDate = rawDateString.asDate
            // Assert
            XCTAssertEqual(resultDate, expectedDate)
        }
    }
    
    func test_String_asDate_returnExpectedHours() {
        for hour in 0...23 {
            // Arrange
            let rawDateString = "1970-01-01T\(hour):00:00.000+00:00"
            let expectedDate = Date(timeIntervalSince1970: Double(3600*hour))
            // Act
            let resultDate = rawDateString.asDate
            // Assert
            XCTAssertEqual(resultDate, expectedDate)
        }
    }
    
    func test_String_asDate_returnExpectedDays() {
        for day in 0...30 {
            // Arrange
            let rawDateString = "1970-01-\(day+1)T00:00:00.000+00:00"
            let expectedDate = Date(timeIntervalSince1970: Double(24*3600*day))
            // Act
            let resultDate = rawDateString.asDate
            // Assert
            XCTAssertEqual(resultDate, expectedDate)
        }
    }
    
    func test_String_asDate_returnExpectedMonths() {
        // Arrange
        let rawDateString = "1970-02-01T00:00:00.000+00:00"
        let expectedDate = Date(timeIntervalSince1970: Double(31*24*3600))
        // Act
        let resultDate = rawDateString.asDate
        // Assert
        XCTAssertEqual(resultDate, expectedDate)
    }
    
    func test_String_asDate_returnExpectedYears() {
        // Arrange
        let rawDateString = "1971-01-01T00:00:00.000+00:00"
        let expectedDate = Date(timeIntervalSince1970: Double(365*24*3600))
        // Act
        let resultDate = rawDateString.asDate
        // Assert
        XCTAssertEqual(resultDate, expectedDate)
    }
    
}
