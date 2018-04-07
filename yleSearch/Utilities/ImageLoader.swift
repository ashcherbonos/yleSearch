//
//  ImageLoader.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/2/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

protocol ImageLoaderDelegate: class {
    func imageDidLoad (success: Bool)
}

class ImageLoader {
    
    weak var delegate: ImageLoaderDelegate?
    private let cache: ImageCacher
    
    init(cache: ImageCacher) {
        self.cache = cache
    }
    
    func load( url: URL?, intoImageView imageView: UIImageView){
        guard let url = url else {return}
        if let cachedImage = cache[url] {
            imageView.image = cachedImage
            delegate?.imageDidLoad(success: true)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let data = data,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.imageDidLoad(success: false)
                    }
                    return
            }
            self.cache[url] = image
            DispatchQueue.main.async { [weak self] in
                self?.animateAppearance(image, in: imageView)
                //imageView.image = image
                self?.delegate?.imageDidLoad(success: true)
            }
        }
        task.resume()
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


