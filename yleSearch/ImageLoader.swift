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
    
    private let cache = NSCache<NSString, UIImage>()
    
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
    
    func load( url: URL?, intoImageView imageView: UIImageView?, withStub title: String){
        
        guard let guardedImageView = imageView,
            let url = url
            else {return}
        
        if let cachedImage = cache[url] {
            guardedImageView.image = cachedImage
            return
        }
        
        makeStub(for: guardedImageView, withLabel: title)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, response.statusCodeIsOK,
                let data = data,
                let image = UIImage(data: data)
                else { return }
            self.cache[url] = image
            DispatchQueue.main.async {
                guard let stillExistingImageView = imageView
                    else { return }
                self.animateAppearance(image, in: stillExistingImageView)
            }
        }
        task.resume()
    }
    
    func emptyCache() {
        cache.empty()
    }
    
    private func makeStub(for imageView: UIImageView, withLabel label: String){
        imageView.image = UIImage(inCircleOfSize: CGSize(width: 52 , height: 52), label: label)
    }
    
    private func animateAppearance(_ image: UIImage, in imageView: UIImageView){
        UIView.transition(with: imageView,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: { imageView.image = image },
                          completion: nil)
    }
}
