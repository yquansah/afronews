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

class MainNewsController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    // Define variables
    private var mainArticles = ArticleStore()
    private var savedArticles = ArticleStore()
    private var api: API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = API()
        populateRequest()
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    func populateRequest() {
        var params: [String: Any] = ["q": "Ghana", "sortBy": "publishedAt", "pageSize": 10]
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
            newArticle.imageURL = result["urlToImage"].stringValue
            newArticle.publishedAt = result["publishedAt"].stringValue
            
            mainArticles.allArticles.append(newArticle)
        }
        tableview.reloadData()
    }
    
    // MARK:- Filter Button
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        // Present the filter view controller on a navigation controller
        let layout = UICollectionViewFlowLayout()
        let filterView = FilterViewController(collectionViewLayout: layout)
        let navCon = UINavigationController(rootViewController: filterView)
        navCon.modalPresentationStyle = .fullScreen
        self.present(navCon, animated: true, completion: nil)
        
    }
}

extension MainNewsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArticles.allArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pulseCell", for: indexPath) as! NewsMainCell
        cell.updateCell(with: mainArticles.allArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        //detailVC.updateDetailView(with: mainArticles.allArticles[indexPath.row])
        detailVC.auth = mainArticles.allArticles[indexPath.row].author!
        detailVC.givenTitle = mainArticles.allArticles[indexPath.row].title
        detailVC.mainDes = mainArticles.allArticles[indexPath.row].description
        detailVC.link = mainArticles.allArticles[indexPath.row].url
        detailVC.image = mainArticles.allArticles[indexPath.row].imageURL
        
        //Style A
        detailVC.providesPresentationContextTransitionStyle = true
        detailVC.definesPresentationContext = true
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        detailVC.view.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        
        self.view.addSubview(detailVC.view)
        self.addChild(detailVC)
        detailVC.didMove(toParent: self)
        
        detailVC.updateDetailView()
        //  detailVC.view.frame = CGRect(x: 20, y: 20, width: 370, height: 700) // Needed with style A
        
        //Style B
        //        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        //        detailVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        //        detailVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        //        detailVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        //        detailVC.view.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.92).isActive = true
        //        detailVC.view.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.92).isActive = true
        
    }
    
    // MARK: - Persistency functions
    
    func saveSelectedArticles() {
        
        let jsonEncoder = JSONEncoder()
        
        if let data = try? jsonEncoder.encode(savedArticles) {
            
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "SelectedArticles")
        }
        
    }
    
    func loadSelectedArticles() {
        
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "SelectedArticles") as? Data {
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                savedArticles = try jsonDecoder.decode(ArticleStore.self, from: data)
                
            } catch {
                
                let ac = UIAlertController(title: "Load error", message: "Cound not load articles.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(ac, animated: true)
            }
        }
        
    }
    
    func saveFilter() {
        //Pending Filter functionality
    }
    
    func loadFilter() {
        //Pending Filter functionality
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
