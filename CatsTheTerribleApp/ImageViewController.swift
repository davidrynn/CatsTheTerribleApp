//
//  ImageViewController.swift
//  CatsTheTerribleApp
//
//  Created by Rynn, David on 10/22/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit
import ImageIO

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var randomImageButton: UIButton!
    @IBOutlet weak var gifImageButton: UIButton!
    var networkClient: NetworkClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkClient = NetworkClient()
        loadMedia(type: .random)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadMedia(type: CallReturnType) {
        guard let client = networkClient else { return }
        self.label.text = "Download Started"
        client.getMediaItems(type: type) { data, error in
            DispatchQueue.main.async {
                if let data = data {
                    switch type {
                    case .random, .tag(type.description), .text(type.description):
                        if let image = UIImage(data: data) {
                            self.imageView.image = image }
                        else {
                            self.label.text = "Error loading image"
                            }
                    case .gif:
                        if let gif = UIImage.gifImageWithData(data) {
                            self.imageView.image = gif
                        }
                    default:
                        self.label.text = "No known call type"
                        return
                    }
                    self.label.text = "Loaded"

                } else {
                    self.label.text = "ERROR LOADING"
                }
                self.view.setNeedsLayout()
            }
        }

    }

    @IBAction func randomImageButtonTapped(_ sender: Any) {
        loadMedia(type: .random)
    }
    
    @IBAction func gifButtonTapped(_ sender: Any) {
        loadMedia(type: .gif)
    }
    
}

