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

class MainNewsController: UITableViewController {
    
    // Define variables
    private var articleStore: ArticleStore = ArticleStore()
    private var api: API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = API()
        populateRequest()
        
    }
    
    func populateRequest() {
        
        var params: [String: Any] = ["q": "cameroon", "sortBy": "publishedAt", "pageSize": 10]
        api.makeRequest(index: 0, params: &params) { response in
            let data = JSON(response)
            self.parse(json: data)
        }
    }
    
    func parse(json: JSON) {
        
        for result in json["articles"].arrayValue {
            let newArticle = Article()
            newArticle.title = result["title"].stringValue
            newArticle.description = result["description"].stringValue
            newArticle.url =  result["url"].stringValue
            newArticle.author = result["source"]["name"].stringValue
            newArticle.content = result["content"].stringValue
            newArticle.imageURL = result["imageURL"].stringValue
            newArticle.publishedAt = result["publishedAt"].stringValue
            
            articleStore.allArticles.append(newArticle)
        }
        tableView.reloadData()
    }

}

extension MainNewsController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleStore.allArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pulseCell", for: indexPath) as! NewsMainCell
        
        cell.updateCell(with: articleStore.allArticles[indexPath.row])
        return cell
    }
    
}
