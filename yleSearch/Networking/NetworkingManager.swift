//
//  NetworkingManager.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/8/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

protocol NetworkingManaging {
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkingManager: NetworkingManaging {
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}


class NetworkingManagerMock: NetworkingManaging {
    
    private var data: Data?
    private var urlResponse: URLResponse?
    private var error: Error?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?){
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, urlResponse, error)
    }
}
