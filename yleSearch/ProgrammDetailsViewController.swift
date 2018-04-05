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
        if let imageURL = programm?.fullImageURL  {
            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard error == nil,
                    response.statusCodeIsOK,
                    let data = data,
                    let image = UIImage(data: data)
                    else {
                        DispatchQueue.main.async {
                            
                            UIView.transition(with: self.imageView,
                                              duration: 1,
                                              options: [.transitionCrossDissolve],
                                              animations: {  self.imageView.removeFromSuperview() },
                                              completion: nil)
                        }
                        return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.fadeIn(in: 0.5)
                }
            }
            task.resume()
        }
    }}
    
    @IBOutlet weak var titleLabel: UILabel! {didSet { titleLabel.text = programm?.title }}
    @IBOutlet weak var typeLabel: UILabel!  {didSet { typeLabel.text = programm?.type }}
    @IBOutlet weak var dateLabel: UILabel!  {didSet { dateLabel.text = programm?.dataModified }}
    @IBOutlet weak var descriptionLabel: UILabel! {didSet { descriptionLabel.text = programm?.description }}
    public var programm: TvProgramm? = nil
}
