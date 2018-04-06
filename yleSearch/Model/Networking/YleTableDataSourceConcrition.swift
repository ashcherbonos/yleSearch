//
//  YleQueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/1/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

struct YleURLMaker: URLMaking {
    func makeURL(query: String, offset: Int, limit: Int) -> URL? {
        let appKey = AppConstants.yleAppKey
        let searchURL = "https://external.api.yle.fi/v1/programs/items.json"
        
        var urlComponents = URLComponents(string: searchURL)
        urlComponents?.query = "offset=\(offset)&limit=\(limit)&q=\(query)&\(appKey)"
        
        return urlComponents?.url
    }
}

struct YleJSONParser: JSONParsering {
    
    func parse(_ jsonDictionary: JSONDictionary) -> [CellDataSourcer] {
        guard let data = jsonDictionary["data"] as? [JSONDictionary] else { return []}
        return data.compactMap{parseProgramm($0)}
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

struct YleTableDataSourcerFactory: TableDataSourcerMaker {
    
    private let factory = TableDataSourceFactoryTemplate(urlMaker: YleURLMaker(), parser: YleJSONParser())
    
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSourcer {
        return factory.make(query: query, completion:completion)
    }
}


extension TvProgramm {
    func previewImageURL(size: CGFloat) -> URL? {
        guard let imageID = imageID else { return nil }
        let width = Int(size)
        let height = width
        let fillMode = "c_thumb,r_max"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        return URL(string: urlString)
    }
    
    var fullImageURL: URL? {
        guard let imageID = imageID else { return nil }
        let width = deviceScreenSmollerSideSize
        let height = width
        let fillMode = "c_fill"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        print("fullImageURL = \(urlString)")
        return URL(string: urlString)
    }
    
    private var deviceScreenSmollerSideSize: Int {
        return Int(min(UIScreen.main.bounds.height, UIScreen.main.bounds.height))
    }
}

