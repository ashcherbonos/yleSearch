//
//  QueryService.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

extension URLResponse {
    var statusCodeIsOK: Bool {
        return (self as? HTTPURLResponse)?.statusCode == 200
    }
}

extension Array {
    mutating func appendIfNotNil(_ newElement: Element?) {
        if let element = newElement {
            self.append(element)
        }
    }
}

class QueryService {
    
    init(searchTerm: String, completion: @escaping ([TvProgramm]?) -> ()){
        guard let url = makeURL(from: searchTerm) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, (response?.statusCodeIsOK)!, let data = data else { return }
            let programms = self.parseJSON(data)
            DispatchQueue.main.async {
                completion(programms)
            }
        }
        task.resume()
    }
    
    private func makeURL(from searchTerm: String) -> URL? {
        let appKey = "app_id=73f7299c&app_key=41a235aabc2fc3c4f9bba2627cca97bc"
        let searchURL = "https://external.api.yle.fi/v1/programs/items.json"
        let searchLimit = 20
        let searchOffset = 0
        
        var urlComponents = URLComponents(string: searchURL)
        urlComponents?.query = "offset=\(searchOffset)&limit=\(searchLimit)&q=\(searchTerm)&\(appKey)"
        return urlComponents?.url
    }
    
    typealias JSONDictionary = [String: Any]
    
    private func parseJSON(_ jsonData: Data) -> [TvProgramm] {
        guard let json = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? JSONDictionary else { return [] }
        return parseYleJSON(json)
    }
    
    private func parseYleJSON(_ json: JSONDictionary) -> [TvProgramm] {
        guard let data = json["data"] as? [JSONDictionary] else { return []}
        var tvProgramms: [TvProgramm] = {[]}()
        data.map{parceProgrammFromJSON($0)}.forEach{tvProgramms.appendIfNotNil($0)}
        return tvProgramms
    }
    
    private func parceProgrammFromJSON(_ programmJSON: JSONDictionary) -> TvProgramm? {
        guard let title = (programmJSON["itemTitle"] as? JSONDictionary)?["fi"] as? String,
            let description = (programmJSON["description"] as? JSONDictionary)?["fi"] as? String,
            let dataModified = programmJSON["indexDataModified"] as? String,
            let type = programmJSON["type"] as? String,
            let imageID = (programmJSON["image"] as? JSONDictionary)?["id"] as? String,
            let imageAvailable = (programmJSON["image"] as? JSONDictionary)?["available"] as? Bool
            else { return nil }
        return TvProgramm(title: title,
                          description: description,
                          dataModified: dataModified,
                          type: type,
                          imageID: imageAvailable ? imageID : nil)
    }
}
