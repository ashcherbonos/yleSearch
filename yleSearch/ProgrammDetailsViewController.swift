//
//  ProgrammDetailsViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/29/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class ProgrammDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var image: UIImageView! {didSet {
        
        if let previewImageURL = programm?.fullImageURL  {
            let task = URLSession.shared.dataTask(with: previewImageURL) { data, response, error in
                guard error == nil, (response?.statusCodeIsOK)!, let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image.image = image
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
