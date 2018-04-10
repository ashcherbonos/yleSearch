//
//  Date+timeAgoAsStringTests.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/10/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import XCTest
@testable import yleSearch

class Date_timeAgoAsStringTests: XCTestCase {
    
    let day = 3600.0*24
    
    func test_timeAgoAsString_returnToday(){
        // Arrange
        let date = Date(timeIntervalSinceNow: 0)
        let expectedString = "today"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return1DayAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -1.5*day)
        let expectedString = "1 day ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return3DaysAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -3.5*day)
        let expectedString = "3 days ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return1WeekAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -7.5*day)
        let expectedString = "1 week ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return3WeeksAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -21.5*day)
        let expectedString = "3 weeks ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return1MonthAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -30.5*day)
        let expectedString = "1 month ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return3MonthsAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -90.5*day)
        let expectedString = "3 months ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return1YearAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -365.5*day)
        let expectedString = "1 year ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
    func test_timeAgoAsString_return3YearsAgo(){
        // Arrange
        let date = Date(timeIntervalSinceNow: -(365 * 3 + 0.5)*day)
        let expectedString = "3 years ago"
        // Act
        let resultString = date.timeAgoAsString
        // Assert
        XCTAssertEqual(resultString, expectedString)
    }
    
}
