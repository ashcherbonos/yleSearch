//
//  TvProgramm.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/6/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct TvProgram: CellDataSource {
    let id: String
    let title: String
    let description: String
    let dataModified: Date
    let type: String
    let previewImageURL: URL?
    let fullImageURL: URL?
}
