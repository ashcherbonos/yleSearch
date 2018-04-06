//
//  Constants.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/6/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

struct AppConstants {
    static let yleAppKey = "app_id=73f7299c&app_key=41a235aabc2fc3c4f9bba2627cca97bc"
    static let searchLimit = 20
    static let imagesFadeInDuration = 0.5
    static let previewImageDiameter = 216
    static let previewImageWhiteBorder = 20
    static var previewImageFullSize: Int {return previewImageDiameter + 2 * previewImageWhiteBorder }
    static let searchBarTintColor = UIColor.lightGray
}
