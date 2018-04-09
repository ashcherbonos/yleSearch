//
//  NetworkingManagerMock.swift
//  yleSearchTests
//
//  Created by Oleksandr Shcherbonos on 4/9/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation
@testable import yleSearch

class NetworkingManagerMock: NetworkingManager {
    
    private var data: Data?
    private var urlResponse: URLResponse?
    private var error: Error?
    
    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil){
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            completionHandler(self?.data, self?.urlResponse, self?.error)
        }
    }
}
