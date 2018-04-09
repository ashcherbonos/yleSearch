//
//  ImageLoaderTests.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/9/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import XCTest
@testable import yleSearch

class ImageLoaderWithFadeInTests: XCTestCase {
    
    func test_delegate_notRetained() {
        // Arrange
        class ImageLoaderDelegateMock: ImageLoaderDelegate {
            func imageDidLoad (success: Bool){}
        }
        
        var delegate = ImageLoaderDelegateMock()
        let loadernUnderTest = ImageLoaderWithFadeIn(cache: ImageCache(), networkingManager: NetworkingManagerMock())
        // Act
        loadernUnderTest.delegate = delegate
        delegate = ImageLoaderDelegateMock()
        // Assert
        XCTAssertNil(loadernUnderTest.delegate)
    }
    
    func test_makeStub_setImageIntoImageView() {
        // Arrange
        let loadernUnderTest = ImageLoaderWithFadeIn(cache: ImageCache(), networkingManager: NetworkingManagerMock())
        let imageView = UIImageView()
        // Act
        loadernUnderTest.makeStub(for: imageView, withLabel: "A")
        // Assert
        XCTAssertNotNil(imageView.image)
    }
    
    func test_load_setImageIntoImageView() {
        // Arrange
        class ImageLoaderDelegateMock: ImageLoaderDelegate {
            let expectation: XCTestExpectation
            init(expectation: XCTestExpectation){
                self.expectation = expectation
            }
            func imageDidLoad (success: Bool){
                expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation(description: "handler executed")
        let delegate = ImageLoaderDelegateMock(expectation: expectation)
        let image = UIImage(named: "testImage", in: Bundle(for: ImageLoaderWithFadeInTests.self), compatibleWith: nil)
        let expectedImageData = UIImagePNGRepresentation(image!) as Data?
        let networkingManager = NetworkingManagerMock(data: expectedImageData)
        let loadernUnderTest = ImageLoaderWithFadeIn(cache: ImageCache(), networkingManager: networkingManager)
        let imageView = UIImageView()
        let url = URL(fileURLWithPath: "testURL")
        // Act
        loadernUnderTest.delegate = delegate
        loadernUnderTest.load(url: url, intoImageView: imageView)
        // Assert
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(imageView.image)
        let resultImageData = UIImagePNGRepresentation(imageView.image!);
        XCTAssertEqual(resultImageData, expectedImageData)
    }
}
