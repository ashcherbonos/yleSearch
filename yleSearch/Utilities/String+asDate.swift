//
//  String+asDate.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/10/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

extension String {
    var asDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZ"
        return dateFormatter.date (from: self)
    }
}
