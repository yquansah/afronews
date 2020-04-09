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
    private let endpoint: String!
    
    init() {
        self.endpoint = "https://polar-sea-76936.herokuapp.com/api/everything"
    }
    
    func makeRequest(index: Int, params: inout [String: Any], completion: @escaping (Any) -> Void) {
        Alamofire.request(self.endpoint, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let newsResp = response.result.value!
                completion(newsResp)
            } else {
                print("Error")
            }
        }
    }
}
