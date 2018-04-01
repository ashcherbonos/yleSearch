//
//  YleQueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/1/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct YleURLMaker: URLMaking {
    func makeURL(query: String, offset: Int, limit: Int) -> URL? {
        let appKey = "app_id=73f7299c&app_key=41a235aabc2fc3c4f9bba2627cca97bc"
        let searchURL = "https://external.api.yle.fi/v1/programs/items.json"
        
        var urlComponents = URLComponents(string: searchURL)
        urlComponents?.query = "offset=\(offset)&limit=\(limit)&q=\(query)&\(appKey)"
        
        return urlComponents?.url
    }
}

struct YleJSONParser: JSONParsering {
    
    func parse(_ jsonDictionary: JSONDictionary) -> [CellDataSourcer] {
        guard let data = jsonDictionary["data"] as? [JSONDictionary] else { return []}
        return data.flatMap{parseProgramm($0)}
    }
    
    private func parseProgramm(_ programmJSON: JSONDictionary) -> TvProgramm? {
        guard let id = programmJSON["id"] as? String,
            let title = (programmJSON["itemTitle"] as? JSONDictionary)?["fi"] as? String,
            let description = (programmJSON["description"] as? JSONDictionary)?["fi"] as? String,
            let dataModified = programmJSON["indexDataModified"] as? String,
            let type = programmJSON["type"] as? String,
            let imageID = (programmJSON["image"] as? JSONDictionary)?["id"] as? String,
            let imageAvailable = (programmJSON["image"] as? JSONDictionary)?["available"] as? Bool
            else { return nil }
        return TvProgramm(id: id,
                          title: title,
                          description: description,
                          dataModified: dataModified,
                          type: type,
                          imageID: imageAvailable ? imageID : nil)
    }
}

class YleTableDataSourcerFactory: TableDataSourcerMaker {
   
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSourcer {
        let urlMaker = YleURLMaker()
        let parser = YleJSONParser()
        return TableDataSource (searchTerm: query, urlMaker: urlMaker, parser: parser, completion:completion)
    }
    
    func makeNilObject() -> TableDataSourcer {
        return make(query: ""){}
    }
}

