//
//  NetworkingManager.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/8/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

protocol NetworkingManager {
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkingManagerShared: NetworkingManager {
    func resumeDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
}
