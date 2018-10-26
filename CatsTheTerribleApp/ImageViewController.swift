//
//  ImageViewController.swift
//  CatsTheTerribleApp
//
//  Created by Rynn, David on 10/22/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//
// App Icon credit: Icons made by freepik from Flaticon - halloween black cat

import UIKit
import Photos

class ImageViewController: UIViewController {
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var randomImageButton: UIButton!
    @IBOutlet weak var gifImageButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var visualEffectView: UIVisualEffectView!
    var viewModel: ImageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtons()
        
        setupBlurBackground()
        let service = ImagingService()
        viewModel = ImageViewModel(imagingService: service)
        loadMedia(type: .random)
    }
    
    func loadMedia(type: CallReturnType) {
        activityIndicator.startAnimating()
        self.label.text = "Download Started"
        viewModel.getImage(type: type) { image, error in
            DispatchQueue.main.async {
                if let finalImage = image {
                    //animate image and background blur
                    let timeInterval = 1.0
                    UIView.transition(with: self.imageView, duration: timeInterval, options: .transitionCrossDissolve, animations: {
                        self.imageView.image = finalImage
                        self.visualEffectView.backgroundColor = UIColor(patternImage: finalImage)
                    }, completion: nil)
                } else {
                    switch type {
                    case .tag, .text:
                        self.label.text = "No images for that search"
                    default:
                        self.label.text = "ERROR LOADING"
                    }
                }
            }
            
        }
        self.activityIndicator.stopAnimating()
        self.view.setNeedsLayout()
    }
    
    //    MARK: Setups
    func setupBlurBackground() {
        let effect = UIBlurEffect(style: .light)
        self.visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.frame = self.view.bounds
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
    }
    
    func roundButtons(){
        buttonContainerView.subviews.filter { $0 is UIButton }.forEach { roundButton($0 as! UIButton)}
        
    }
    
    func roundButton(_ button: UIButton) {
        button.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 1, height: 2)
        button.clipsToBounds = true
        button.layer.masksToBounds = false
    }
    //    MARK: Actions
    
    
    @IBAction func randomImageButtonTapped(_ sender: Any) {
        loadMedia(type: .random)
    }
    
    @IBAction func gifButtonTapped(_ sender: Any) {
        loadMedia(type: .gif)
    }
    @IBAction func longPress(_ sender: Any) {
        guard let snapshot: UIImage = imageView.image else {
            label.text = "No image"
            return
        }
        let activityController = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = view.safeAreaLayoutGuide.layoutFrame
        present(activityController, animated: true, completion: {
            self.label.text = "media saved"
        })
    }
    
    @IBAction func tagTapped(_ sender: Any) {
        presentTextInput(title: "Tag term to use for search:") { string in
            guard let text = string else {
                self.label.text = "invalid text for tag"
                return
            }
            self.loadMedia(type: .tag(text))
        }
    }
    
    @IBAction func textInputTapped(_ sender: Any) {
        presentTextInput(title: "Text to use for search:") { string in
            guard let text = string else {
                self.label.text = "invalid text"
                return
            }
            self.loadMedia(type: .text(text))
        }
    }
    
    func presentTextInput(title: String, completion: @escaping (String?) -> ()){
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: title, message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Type Here"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let strongAlert = alert, let textFields = strongAlert.textFields, let text = textFields[0].text {
                completion(text)
            }
        }))
        
        //4. Add cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] _ in
            if let strongAlert = alert {
                strongAlert.dismiss(animated: true) {
                    completion(nil)
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}

