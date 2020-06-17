//
//  ImagePickerViewController.swift
//  Finder
//
//  Created by Hamda Mare on 2020-01-01.
//  Copyright © 2020 Hamda Mare. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var findButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyRoundCornerToButtons(findButton)
        self.applyRoundCornerToButtons(cameraButton)
        
        findButton.isHidden = true
        findButton.isEnabled = false
    }
    
    @IBAction func getImage(_ sender: Any) {
        let imgPickController = UIImagePickerController()
                imgPickController.delegate = self
                
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imgPickController.sourceType = .camera
            self.present(imgPickController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imgPickController.sourceType = .photoLibrary
            self.present(imgPickController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
        findButton.isEnabled = true
        findButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Making buttons looks better
    func applyRoundCornerToButtons(_ object:AnyObject) {
        object.layer.cornerRadius = object.frame.size.width/3
        object.layer?.masksToBounds = true
    }
    
    // Passing image to loading view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let svc = nav.topViewController as! LoadingViewController
        svc.capturedImage = imageView.image!
    }
}
    
