//
//  ViewController.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 6/17/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Request to news api made here
    func makeApiRequest(completionHandler: @escaping (Any) -> Void) {
        var params: [String: String] = ["q": "ghana", "sortBy": "publishedAt"]
        apiRequest(index: 0, params: &params, completion: completionHandler)
    }
}
