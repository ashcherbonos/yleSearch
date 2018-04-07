//
//  ImageCach.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/7/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

fileprivate extension URL {
    var NSString: NSString { return self.absoluteString as NSString}
}

protocol ImageCacher: class {
    subscript(url: URL) -> UIImage? {get set}
    func empty()
}

class ImageCach: ImageCacher {
    
    private let cache = NSCache<NSString, UIImage>()
    
    subscript(url: URL) -> UIImage?{
        get { return cache.object(forKey: url.NSString) }
        set { cache.setObject(newValue!, forKey: url.NSString) }
    }
    
    func empty() {
        cache.removeAllObjects()
    }
}
