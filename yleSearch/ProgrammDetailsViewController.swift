//
//  ProgrammDetailsViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/29/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class ProgrammDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {didSet {
        let imageLoader = ImageLoader()
        imageLoader.load(url: programm?.fullImageURL, intoImageView: imageView) { [weak self] success in
            self?.activityIndicator.stopAnimating()
            if(!success) {
                self?.imageView.removeFromSuperview()
            }
        }
    }}
    
    @IBOutlet weak var titleLabel: UILabel! {didSet { titleLabel.text = programm?.title }}
    @IBOutlet weak var typeLabel: UILabel!  {didSet { typeLabel.text = programm?.type }}
    @IBOutlet weak var dateLabel: UILabel!  {didSet { dateLabel.text = programm?.dataModified }}
    @IBOutlet weak var descriptionLabel: UILabel! {didSet { descriptionLabel.text = programm?.description }}
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var programm: TvProgramm? = nil
    
}
