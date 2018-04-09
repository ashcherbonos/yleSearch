//
//  SearchViewModelTests.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/9/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import XCTest
@testable import yleSearch

class SearchViewModelTests: XCTestCase {
    
    class DelegateMock: SearchViewModelDelegate, DataConsumer {
        let expectation: XCTestExpectation?
        var filledData: CellDataSource? = nil
        init(expectation: XCTestExpectation? = nil){
            self.expectation = expectation
        }
        func updateView() {
            expectation?.fulfill()
        }
        func fill(withData data: CellDataSource, imageLoader: ImageLoader) {
            filledData = data
            expectation?.fulfill()
        }
    }
    
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
    
    func makeSearchViewModel(delegate: SearchViewModelDelegate) -> SearchViewModel {
        let networkManager = NetworkingManagerMock(data: jsonTestData)
        let tableDataSourcerFactory = YleTableDataSourcerFactory(networkManager: networkManager)
        let cache = ImageCache()
        let imageLoaderFactory = ImageLoaderWithFadeInFactory(cache: cache, networkingManager: networkManager)
        return SearchViewModel(delegate: delegate, dataSourceFactory: tableDataSourcerFactory, imageLoaderFactory: imageLoaderFactory, cache: cache)
    }
    
    
    func test_unitTesting_worksCorrect() {
        XCTAssertTrue(true)
    }
    
    func test_delegate_notRetained() {
        // Arrange
        var delegate = DelegateMock()
        // Act
        let mvvmUnderTest = makeSearchViewModel(delegate: delegate)
        delegate = DelegateMock()
        // Assert
        XCTAssertNil(mvvmUnderTest.delegate)
    }
    
    func test_dataCount_isEmptyAtStart(){
        // Arrange
        let expectedDataCount = 0
        // Act
        let mvvmUnderTest = makeSearchViewModel(delegate: DelegateMock())
        let returnedDataCount = mvvmUnderTest.dataCount
        // Assert
        XCTAssertEqual(returnedDataCount, expectedDataCount)
    }
    
    func test_search_returnExpectedDataAmount(){
        // Arrange
        let expectedDataCount = 2
        let expectation = XCTestExpectation(description: "handler executed")
        let delegate =  DelegateMock(expectation: expectation)
        let mvvmUnderTest = makeSearchViewModel(delegate:delegate)
        // Act
        mvvmUnderTest.search(for: "test search string")
        wait(for: [expectation], timeout: 5.0)
        let returnedDataCount = mvvmUnderTest.dataCount
        // Assert
        XCTAssertEqual(returnedDataCount, expectedDataCount)
    }
    
    func test_loadMoreData_returnExpectedDataAmount(){
        // Arrange
        let expectedDataCount = 4
        let firstExpectation = XCTestExpectation(description: "handler executed once")
        let secondExpectation = XCTestExpectation(description: "handler executed second time")
        let delegateFirst =  DelegateMock(expectation: firstExpectation)
        let delegateSecond =  DelegateMock(expectation: secondExpectation)
        let mvvmUnderTest = makeSearchViewModel(delegate:delegateFirst)
        // Act
        mvvmUnderTest.search(for: "test search string")
        wait(for: [firstExpectation], timeout: 5.0)
        mvvmUnderTest.delegate = delegateSecond
        mvvmUnderTest.loadMoreData()
        wait(for: [secondExpectation], timeout: 5.0)
        let returnedDataCount = mvvmUnderTest.dataCount
        // Assert
        XCTAssertEqual(returnedDataCount, expectedDataCount)
    }
    
    func test_fill_fillDataConsumer() {
        // Arrange
        let expectedDataCount = 2
        let expectationMVVMLoadData = XCTestExpectation(description: "MVVM load data")
        let delegate = DelegateMock(expectation: expectationMVVMLoadData)
        let mvvmUnderTest = makeSearchViewModel(delegate: delegate)
        let expectationDataConsumerFilled = XCTestExpectation(description: "DataConsumer filled")
        let testDataConsumer = DelegateMock(expectation: expectationDataConsumerFilled)
        // Act
        mvvmUnderTest.search(for: "test search string")
        wait(for: [expectationMVVMLoadData], timeout: 5.0)
        XCTAssertEqual(mvvmUnderTest.dataCount, expectedDataCount)
        mvvmUnderTest.fill(consumer: testDataConsumer, withIndex: 0)
        wait(for: [expectationDataConsumerFilled], timeout: 5.0)
        // Assert
        XCTAssertNotNil(testDataConsumer.filledData)
    }
}
