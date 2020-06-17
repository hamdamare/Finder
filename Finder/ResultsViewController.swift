//
//  ResultsViewController.swift
//  Finder
//
//  Created by Hamda Mare on 2020-01-05.
//  Copyright © 2020 Hamda Mare. All rights reserved.
//

import UIKit
import WebKit

class ResultsViewController: UIViewController {
    var averagePrice:Int = 0
    var searchUrl:URL?
    var itemInImage:String = ""
    @IBOutlet var webView: WKWebView!
    @IBOutlet var productText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.showWebpage()
        self.showProductInfo()
    }
    
    func showWebpage() {
        let webRequest = URLRequest(url: self.searchUrl!)
        webView.load(webRequest)
    }
    
    func showProductInfo() {
        let textToShow = String(format:"Average price of %@ is %d dollars", itemInImage,averagePrice)
        productText.text = textToShow
    }
}
