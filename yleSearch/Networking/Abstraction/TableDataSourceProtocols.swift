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

protocol URLMaker  {
    func makeURL(query: String, offset: Int, limit: Int) -> URL?
}

protocol JSONParser {
    func parse(_ jsonDictionary: Data) -> [CellDataSource]?
}

protocol TableDataSource {
    var count: Int {get}
    subscript (index: Int) -> CellDataSource {get}
    func loadData(amount: Int)
}

protocol TableDataSourcerMaker {
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSource
}

struct TableDataSourceNullObject: TableDataSource {
    let count = 0
    subscript(index: Int) -> CellDataSource { fatalError("TableDataSourcer did not set") }
    func loadData(amount: Int) { fatalError("TableDataSourcer did not set") }
}
