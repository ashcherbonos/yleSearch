//
//  TvProgramm.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/6/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct TvProgramm: CellDataSource {
    let id: String
    let title: String
    let description: String
    let dataModified: String
    let type: String
    let imageID: String?
    let previewImageURL: URL?
    let fullImageURL: URL?
}
