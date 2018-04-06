//
//  QueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct TableDataSourceFactoryTemplate: TableDataSourcerMaker {
    let urlMaker: URLMaking
    let parser: JSONParsering
    
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSourcer {
        return TableDataSource (searchTerm: query, urlMaker: urlMaker, parser: parser, completion:completion)
    }
}

class TableDataSource: TableDataSourcer{
    var count:Int {return items.count}
    
    subscript(index: Int) -> CellDataSourcer {
        get{
            return items[index]
        }
    }
    
    private var items: [CellDataSourcer]
    private let searchTerm: String
    private let parser: JSONParsering
    private let urlMaker: URLMaking
    private let completion: () -> ()
    private var moreResultsAvaliable = true;
    
    init(searchTerm: String, urlMaker: URLMaking, parser: JSONParsering, completion: @escaping () -> ()) {
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
                let items = self?.parseJSON(data)
                else { return }
            self?.moreResultsAvaliable = (items.count > 0)
            self?.items += items
            DispatchQueue.main.async { self?.completion() }
        }
        task.resume()
    }
    
    private func parseJSON(_ jsonData: Data) -> [CellDataSourcer]? {
        guard let json = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? JSONDictionary else { return nil }
        return parser.parse(json)
    }
}
