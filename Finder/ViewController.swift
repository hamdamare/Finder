//
//  ViewController.swift
//  Finder
//
//  Created by Hamda Mare on 2019-12-27.
//  Copyright © 2019 Hamda Mare. All rights reserved.
//
import UIKit
class ViewController: UIViewController {
    
    @IBOutlet var CameraButton: UIButton!
    @IBOutlet var PlayGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    
        playGifImages(strName: "CameraEyes")
        
        // Starting vc switch timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.perform(#selector(self.switchView))
        })
    }
    
    func playGifImages(strName: String) {
        let gifImg = UIImage.gif(name:strName)
        PlayGif.animationImages = gifImg?.images
        PlayGif.animationDuration = gifImg!.duration
        PlayGif.animationRepeatCount = 0
        PlayGif.startAnimating()
    }
    
    @objc func switchView() {
        let nextViewController = storyboard?.instantiateViewController(identifier: "ImagePickerViewController") as! ImagePickerViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

