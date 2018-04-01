//
//  QueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

extension Optional where Wrapped == URLResponse  {
    var statusCodeIsOK: Bool {
        return (self as? HTTPURLResponse)?.statusCode == 200
    }
}

class TableDataSource: TableDataSourcer{
    var count:Int {return items.count}
    
    subscript(index: Int) -> CellDataSource {
        get{
            return items[index]
        }
    }
    
    private var items: [CellDataSource]
    private let searchTerm: String
    private let parser: JSONParsering
    private let urlMaker: URLMaking
    private let completion: () -> ()
    private var noMoreResultsAvaliable = false;
    
    required init(searchTerm: String, urlMaker: URLMaking, parser: JSONParsering, completion: @escaping () -> ()) {
        self.searchTerm = searchTerm
        self.urlMaker = urlMaker
        self.parser = parser
        self.completion = completion
        self.items = []
    }
    
    func giveNext(_ quantity: Int) {
        guard !noMoreResultsAvaliable, let url = urlMaker.makeURL(query: searchTerm, offset: items.count, limit: quantity) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, response.statusCodeIsOK, let data = data else { return }
            let items = self.parseJSON(data)
            self.noMoreResultsAvaliable = (items.count == 0)
            self.items += items
            DispatchQueue.main.async { self.completion() }
        }
        task.resume()
    }
    
    private func parseJSON(_ jsonData: Data) -> [CellDataSource] {
        guard let json = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? JSONDictionary else { return [] }
        return parser.parse(json)
    }
}
