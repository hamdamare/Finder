//
//  LoadingViewController.swift
//  Finder
//
//  Created by Hamda Mare on 2020-01-03.
//  Copyright © 2020 Hamda Mare. All rights reserved.
//

import UIKit
import AVKit
import Vision
import Foundation
import SwiftSoup
//import FirebaseMLVision

class LoadingViewController: UIViewController {
    var capturedImage:UIImage?
    var classifierID:String = ""
    var classifierConfidence:float_t?
    var textInImageOCR:String = ""
    //var textRecognizer: VisionTextRecognizer!
    var searchURL:URL = URL(string: "https://www.amazon.ca")! //default URL
    var averageImagePrice:Int = 0
    var useOCR = true
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playGifImages(strName: "loading")
        analyzeImage()
        runSearchForImage()
        
        
        // Starting vc switch timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.perform(#selector(self.switchView))
        })
    }
    
    func playGifImages(strName: String) {
        let gifImg = UIImage.gif(name:strName)
        imageView.animationImages = gifImg?.images
        imageView.animationDuration = gifImg!.duration
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func analyzeImage() {
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        let request = VNCoreMLRequest(model: model, completionHandler: {(finishedReq, err) in

            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservaton = results.first else {return}
            
            self.classifierID = firstObservaton.identifier.split{$0 == " "}.map(String.init)[0]
            self.classifierConfidence = firstObservaton.confidence
            //self.runImageTextRecognition()
            
            print(firstObservaton.identifier.split{$0 == " "}.map(String.init)[0])
        })
        try? VNImageRequestHandler(cgImage: (capturedImage?.cgImage)!, options: [:]).perform([request])
        
    }
    
    func getSearchString()->String {
        print(classifierID)
        let urlFirstPart = "https://www.amazon.ca/s?k="
        let urlSecondPart = "&ref=nb_sb_noss_2"
        if textInImageOCR.count > 1 || self.useOCR == false {
            return String(format:"%@%@%@", urlFirstPart,classifierID,urlSecondPart)
        } else {
            return  String(format:"%@%@+%@%@", urlFirstPart,textInImageOCR,classifierID,urlSecondPart)
        }
    }
    
    // Getting average price of object + where to find object
    func runSearchForImage(){
        searchURL = URL(string: self.getSearchString())!
        var averagePrice = 0
        
        let task = URLSession.shared.dataTask(with: searchURL) {(data, response, error) in
            guard let data = data else {
                print("No data found")
                if self.useOCR == true {
                    // OCR causes issues sometime so searching without it
                    self.useOCR = false
                    self.analyzeImage()
                }
                
                return
            }
            
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
                print("cant cast data into string")
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(htmlString)
                let price = try doc.getElementsByClass("a-price-whole").array()
                
                for i in 0..<price.count {
                    let priceText = try price[i].text()
                    let myInt = (priceText as NSString).integerValue
                    averagePrice += myInt
                }
                self.averageImagePrice = averagePrice/price.count
            } catch {print("Error")}
        }
        
        self.useOCR = true
        task.resume()
    }
    
    // Switching to results view
    @objc func switchView() {
        let nextViewController = storyboard?.instantiateViewController(identifier: "ResultsViewController") as! ResultsViewController
        nextViewController.averagePrice = self.averageImagePrice
        nextViewController.searchUrl = searchURL
        nextViewController.itemInImage = self.classifierID
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
