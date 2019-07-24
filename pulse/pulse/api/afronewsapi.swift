//
//  afronewsapi.swift
//  pulse
//
//  Created by Yoofi Quansah on 7/20/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let API_KEY = "dd73f84f90d342c8ba07f4c6ec2e063e"
let URLS = ["https://newsapi.org/v2/everything", "https://newsapi.org/v2/top-headlines"]

func apiRequest(index: Int, params: inout [String: String], completion: @escaping (Any) -> Void) {
    params["apiKey"] = API_KEY

    Alamofire.request(URLS[index], method: .get, parameters: params).responseJSON { response in
        if response.result.isSuccess {
            let newsResp = response.result.value!
            print("Success in networking")
            completion(newsResp)
        } else {
            print("Error")
        }
    }
}
