//
//  YleQueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/1/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

struct YleURLMaker: URLMaker {
    func makeURL(query: String, offset: Int, limit: Int) -> URL? {
        let appKey = AppConstants.yleAppKey
        let searchURL = "https://external.api.yle.fi/v1/programs/items.json"
        
        var urlComponents = URLComponents(string: searchURL)
        urlComponents?.query = "offset=\(offset)&limit=\(limit)&q=\(query)&\(appKey)"
        
        return urlComponents?.url
    }
}

struct YleJSONParser: JSONParser {
    
    func parse(_ jsonData: Data) -> [CellDataSource]? {
        guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? JSONDictionary,
            let data = jsonDictionary["data"] as? [JSONDictionary] else { return nil}
        return data.compactMap{parseProgramm($0)}
    }
    
    private func parseProgramm(_ programmJSON: JSONDictionary) -> TvProgram? {
        guard let id = programmJSON["id"] as? String,
            let title = (programmJSON["itemTitle"] as? JSONDictionary)?["fi"] as? String,
            let description = (programmJSON["description"] as? JSONDictionary)?["fi"] as? String,
            let dataModified = programmJSON["indexDataModified"] as? String,
            let type = programmJSON["type"] as? String,
            let imageID = (programmJSON["image"] as? JSONDictionary)?["id"] as? String,
            let imageAvailable = (programmJSON["image"] as? JSONDictionary)?["available"] as? Bool
            else { return nil }
        return TvProgram(id: id,
                          title: title,
                          description: description,
                          dataModified: dataModified,
                          type: type,
                          previewImageURL: previewImageURL(for: imageID),
                          fullImageURL: fullImageURL(for: imageID))
    }
    
    private func previewImageURL(for imageID: String?) -> URL? {
        guard let imageID = imageID else { return nil }
        let width = AppConstants.previewImageFullSize
        let height = width
        let fillMode = "c_thumb,r_max/bo_\(AppConstants.previewImageWhiteBorder)px_solid_white"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        return URL(string: urlString)
    }
    
    private func fullImageURL(for imageID: String?) -> URL? {
        guard let imageID = imageID else { return nil }
        let width = deviceScreenSmollerSideSize
        let height = width
        let fillMode = "c_fill"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        return URL(string: urlString)
    }
    
    private var deviceScreenSmollerSideSize: Int {
        return Int(min(UIScreen.main.bounds.height, UIScreen.main.bounds.width))
    }
}

struct YleTableDataSourcerFactory: TableDataSourcerMaker {
    
    private let factory: TableDataSourcerMaker
    
    init(networkManager: NetworkingManager){
        factory = TableDataSourceFactoryTemplate(urlMaker: YleURLMaker(), parser: YleJSONParser(), networkManager: networkManager)
    }
    
    func make(query: String, completion: @escaping () -> ()) ->  TableDataSource {
        return factory.make(query: query, completion:completion)
    }
}
