//
//  QueryServiceProtocols.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/1/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol CellDataSourcer {}

protocol URLMaking  {
    func makeURL(query: String, offset: Int, limit: Int) -> URL?
}

protocol JSONParsering {
    func parse(_ jsonDictionary: JSONDictionary) -> [CellDataSourcer]
}

protocol TableDataSourcer {
    var count: Int {get}
    subscript (index: Int) -> CellDataSourcer {get}
    func loadData(amount: Int)
}

protocol TableDataSourcerMaker {
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSourcer
}

struct TableDataSourceNullObject: TableDataSourcer {
    let count = 0
    subscript(index: Int) -> CellDataSourcer { fatalError("TableDataSourcer did not set") }
    func loadData(amount: Int) { fatalError("TableDataSourcer did not set") }
}
