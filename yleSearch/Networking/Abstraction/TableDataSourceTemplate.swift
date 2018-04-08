//
//  QueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct TableDataSourceFactoryTemplate: TableDataSourcerMaker {
    let urlMaker: URLMaker
    let parser: JSONParser
    
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSource {
        return TableDataSourceTemplate (searchTerm: query, urlMaker: urlMaker, parser: parser, completion:completion)
    }
}

class TableDataSourceTemplate: TableDataSource{
    var count:Int {return items.count}
    
    subscript(index: Int) -> CellDataSource {
        get{
            return items[index]
        }
    }
    
    private var items: [CellDataSource]
    private let searchTerm: String
    private let parser: JSONParser
    private let urlMaker: URLMaker
    private let completion: () -> ()
    private var moreResultsAvaliable = true;
    
    init(searchTerm: String, urlMaker: URLMaker, parser: JSONParser, completion: @escaping () -> ()) {
        self.searchTerm = searchTerm
        self.urlMaker = urlMaker
        self.parser = parser
        self.completion = completion
        self.items = []
    }
    
    func loadData(amount: Int) {
        guard moreResultsAvaliable,
            let url = urlMaker.makeURL(query: searchTerm, offset: items.count, limit: amount)
            else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                let data = data,
                let items = self?.parser.parse(data)
                else { return }
            self?.moreResultsAvaliable = (items.count > 0)
            self?.items += items
            DispatchQueue.main.async { self?.completion() }
        }
        task.resume()
    }
}
