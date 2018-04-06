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
    
    func load( url: URL?, intoImageView imageView: UIImageView?, complition: ((Bool)->())? = nil ){
        
        guard let guardedImageView = imageView,
            let url = url
            else {return}
        
        if let cachedImage = cache[url] {
            guardedImageView.image = cachedImage
            complition?(true)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let data = data,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async { complition?(false) }
                    return
            }
            self.cache[url] = image
            DispatchQueue.main.async {
                guard let stillExistingImageView = imageView // TODO: - check if imageView still expected this(!) url
                    else { return }
                self.animateAppearance(image, in: stillExistingImageView)
                complition?(true)
            }
        }
        task.resume()
    }
    
    func emptyCache() {
        cache.empty()
    }
    
    func makeStub(for imageView: UIImageView, withLabel label: String){
        let size = CGSize(width: AppConstants.previewImageFullSize, height: AppConstants.previewImageFullSize)
        let diameter = CGFloat(AppConstants.previewImageDiameter)
        imageView.image = UIImage(size: size, withCircleDiametr: diameter,  stubChar: label.first)
    }
    
    private func animateAppearance(_ image: UIImage, in imageView: UIImageView){
        UIView.transition(with: imageView,
                          duration: AppConstants.imagesFadeInDuration,
                          options: [.transitionCrossDissolve],
                          animations: { imageView.image = image },
                          completion: nil)
    }
}


