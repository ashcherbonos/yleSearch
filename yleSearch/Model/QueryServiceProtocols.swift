//
//  QueryServiceProtocols.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/1/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol CellDataSource {}

protocol URLMaking  {
    func makeURL(query: String, offset: Int, limit: Int) -> URL?
}

protocol JSONParsering {
    func parse(_ jsonDictionary: JSONDictionary) -> [CellDataSource]
}

protocol TableDataSourcer {
    var count: Int {get}
    subscript (index: Int) -> CellDataSource {get}
    func giveNext(_: Int)
    init(searchTerm: String, urlMaker: URLMaking, parser: JSONParsering, completion: @escaping () -> ())
}

protocol TableDataSourcerMaker {
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSourcer
}
