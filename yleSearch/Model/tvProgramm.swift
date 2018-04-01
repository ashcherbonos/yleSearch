//
//  programmItem.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct TvProgramm: CellDataSourcer {
    let id: String
    let title: String
    let description: String
    let dataModified: String
    let type: String
    let imageID: String?
}

extension TvProgramm {
    var previewImageURL: URL? {
        guard let imageID = imageID else { return nil }
        let width = 52
        let height = 52
        let fillMode = "c_thumb,r_max"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        print(urlString)
        return URL(string: urlString)
    }
    
    var fullImageURL: URL? {
        guard let imageID = imageID else { return nil }
        let width = 375
        let height = 232
        let fillMode = "c_fill"
        let imageFormat = ".png"
        let urlString = "https://images.cdn.yle.fi/image/upload/w_\(width),h_\(height),\(fillMode)/\(imageID)\(imageFormat)"
        print(urlString)
        return URL(string: urlString)
    }
}
