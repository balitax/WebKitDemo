//
//  ViewController.swift
//  WebKitDemo
//
//  Created by BriceZhao on 2019/9/23.
//  Copyright © 2019 BriceZhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func toWKWebView(_ sender: UIButton) {
        let web = WKWebViewController()
        self.navigationController?.pushViewController(web, animated: true)
    }
    
}

