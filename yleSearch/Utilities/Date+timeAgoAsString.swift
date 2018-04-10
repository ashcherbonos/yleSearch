//
//  DateFromStringConverter.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/9/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

extension Date {
    var timeAgoAsString: String {
        
        let day = 3600*24
        let week = day*7
        let month = day*30
        let year = month*12
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        switch secondsAgo {
        case 0...day:
            return "today"
        case day...(2*day):
            return "1 day ago"
        case day...week:
            return "\(secondsAgo/day) days ago"
        case week...(2*week):
            return "1 week ago"
        case week...month:
            return "\(secondsAgo/week) weeks ago"
        case month...(2*month):
            return "1 month ago"
        case month...year:
            return "\(secondsAgo/month) months ago"
        case year...(2*year):
            return "1 year ago"
        default:
            return "\(secondsAgo/year) years ago"
        }
    }
}
