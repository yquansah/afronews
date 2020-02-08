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

class API {
    private let apiKey: String!
    private let endpoints: [String]!
    
    init() {
        self.endpoints = ["https://newsapi.org/v2/everything", "https://newsapi.org/v2/top-headlines"]
        self.apiKey = "dd73f84f90d342c8ba07f4c6ec2e063e"
    }
    
    func makeRequest(index: Int, params: inout [String: Any], completion: @escaping (Any) -> Void) {
        params["apiKey"] = self.apiKey
        Alamofire.request(self.endpoints[index], method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let newsResp = response.result.value!
                completion(newsResp)
            } else {
                print("Error")
            }
        }
    }
}
