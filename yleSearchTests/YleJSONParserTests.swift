//
//  YleJSONParserTests.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/8/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import XCTest
@testable import yleSearch

class YleJSONParserTests: XCTestCase {
    
    var parserUnderTest: YleJSONParser!
    var result: [CellDataSource]?
    var firstItem: TvProgram?
    
    let jsonTestData: Data = {
        let bundle = Bundle(for: YleJSONParserTests.self)
        guard let url = bundle.url(forResource: "test", withExtension: "json")
            else {
                fatalError("Missing file: test.json")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Can`t parse test.json")
        }
    }()
    
    override func setUp() {
        super.setUp()
        parserUnderTest = YleJSONParser()
        result = parserUnderTest.parse(jsonTestData)
        firstItem = result?[0] as? TvProgram
    }
    
    func test_unitTesting_worksCorrect() {
        XCTAssertTrue(true)
    }
    
    func test_parse_returnNotNil(){
        // Arrange
        // Act
        // Assert
        XCTAssertNotNil(result)
    }
    
    func test_parse_returnExpectedDataAmount(){
        // Arrange
        let expectedCount = 2
        // Act
        let resultCount = result?.count
        // Assert
        XCTAssertEqual(expectedCount, resultCount)
    }
    
    func test_parse_returnTvProgramType(){
        // Arrange
        // Act
        // Assert
        XCTAssertNotNil(firstItem)
    }
    
    func test_parse_returnExpectedTitle(){
        // Arrange
        let expectedTitle = "Oktonautit ja merikilpikonnanpoikaset"
        // Act
        let resultTitle = firstItem?.title
        // Assert
        XCTAssertEqual(expectedTitle, resultTitle)
    }
    
    func test_parse_returnExpectedDescription(){
        // Arrange
        let expectedDescription = "Oktonautit ja merikilpikonnanpoikaset. Suuri aalto uhkaa pieniä merikilpikonnanpoikasia."
        // Act
        let resultDescription = firstItem?.description
        // Assert
        XCTAssertEqual(expectedDescription, resultDescription)
    }
    
    func test_parse_returnExpectedDataModified(){
        // Arrange
        let expectedDataModified = "2018-04-08T12:03:51.797+03:00"
        // Act
        let resultDataModified = firstItem?.dataModified
        // Assert
        XCTAssertEqual(expectedDataModified, resultDataModified)
    }
    
    func test_parse_returnExpectedProgramType(){
        // Arrange
        let expectedProgramType = "TVProgram"
        // Act
        let resultProgramType = firstItem?.type
        // Assert
        XCTAssertEqual(expectedProgramType, resultProgramType)
    }
    
    func test_parse_returnExpectedPreviewImageURL(){
        // Arrange
        let size = AppConstants.previewImageFullSize
        let border = AppConstants.previewImageWhiteBorder
        let expectedPreviewImageURL = URL(string: "https://images.cdn.yle.fi/image/upload/w_\(size),h_\(size),c_thumb,r_max/bo_\(border)px_solid_white/13-1-3391628-1522918692260.png")
        // Act
        let resultPreviewImageURL = firstItem?.previewImageURL
        // Assert
        XCTAssertEqual(expectedPreviewImageURL, resultPreviewImageURL)
    }
    
    func test_parse_returnExpectedFullImageURL(){
        // Arrange
        let size = Int(min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
        let expectedFullImageURL = URL(string: "https://images.cdn.yle.fi/image/upload/w_\(size),h_\(size),c_fill/13-1-3391628-1522918692260.png")
        // Act
        let resultFullImageURL = firstItem?.fullImageURL
        // Assert
        XCTAssertEqual(expectedFullImageURL, resultFullImageURL)
    }
}
