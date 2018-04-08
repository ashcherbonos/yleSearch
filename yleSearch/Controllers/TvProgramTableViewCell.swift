//
//  TvProgrammTableViewCell.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/7/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class TvProgramTableViewCell: UITableViewCell, DataConsumer {
    
    private var imageLoader: ImageLoader!
    
    func fill(withData dataSource: CellDataSource, imageLoader: ImageLoader){
        let programm = dataSource as! TvProgram
        textLabel!.text = programm.title
        detailTextLabel!.text = programm.description
        self.imageLoader = imageLoader
        self.imageLoader.makeStub(for: imageView!, withLabel: programm.title)
        let url = programm.previewImageURL
        self.imageLoader.load(url: url, intoImageView: imageView!)
    }
}
