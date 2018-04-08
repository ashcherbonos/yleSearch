//
//  ProgrammDetailsViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/29/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class TvProgramDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {didSet { imageLoader.load(url: programm?.fullImageURL, intoImageView: imageView) }}
    @IBOutlet weak var titleLabel: UILabel! {didSet { titleLabel.text = programm.title }}
    @IBOutlet weak var typeLabel: UILabel!  {didSet { typeLabel.text = programm.type }}
    @IBOutlet weak var dateLabel: UILabel!  {didSet { dateLabel.text = programm.dataModified }}
    @IBOutlet weak var descriptionLabel: UILabel! {didSet { descriptionLabel.text = programm.description }}
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var programm: TvProgram!
    private var imageLoader: ImageLoader!
}

extension TvProgramDetailsViewController: DataConsumer {
    
    func fill(withData dataSource: CellDataSource, imageLoader: ImageLoader) {
        self.programm = dataSource as! TvProgram
        self.imageLoader = imageLoader
        self.imageLoader.delegate = self
    }
}

extension TvProgramDetailsViewController: ImageLoaderDelegate {
    
    func imageDidLoad(success: Bool) {
        activityIndicator.stopAnimating()
        if(!success) {
            imageView.removeFromSuperview()
        }
    }
}

