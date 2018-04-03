//
//  ImageLoader.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/2/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

fileprivate extension URL {
    var NSString: NSString { return self.absoluteString as NSString}
}

fileprivate class ImageCash {
    let cache = NSCache<NSString, UIImage>()
    subscript(url: URL) -> UIImage?{
        get { return cache.object(forKey: url.NSString) }
        set { cache.setObject(newValue!, forKey: url.NSString) }
    }
    func empty() {
        cache.removeAllObjects()
    }
}

struct ImageLoader {
    
    private let cache = ImageCash()
    
    func load(imageView: UIImageView?, url: URL?){
        
        guard let guardedImageView = imageView,
            let url = url
            else {return}
        
        if let cachedImage = cache[url] {
            guardedImageView.image = cachedImage
            return
        }
        
        stub(for: guardedImageView)
       
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, response.statusCodeIsOK,
                let data = data
                else { return }
            let image = UIImage(data: data)
            self.cache[url] = image
            DispatchQueue.main.async {
                guard let imageView = imageView
                    else {return}
                imageView.image = image
            }
        }
        task.resume()
    }
    
    func emptyCache() {
        cache.empty()
    }
    
    private func stub(for imageView: UIImageView){
        imageView.image = UIImage(named: "Blank52")
    }
}
