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
import RealmSwift

class MainNewsController: UIViewController, DonePressed {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    // MARK: - Define variables
    let realm = try! Realm()
    private var mainArticles = ArticleStore()
    private var savedArticle = SavedArticle()
    private var api: API!
    
    lazy var viewToDim: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        uiView.isHidden = true
        
        return uiView
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = API()
        tableview.delegate = self
        tableview.dataSource = self
        
        // Dimming
        view.addSubview(viewToDim)
        viewToDim.frame = view.frame
    }
    
    private func constructQueryParams(countries: String, topics: String) -> [String: Any] {
        let countriesAndTopics = countries + " " + topics
        return ["q": countriesAndTopics, "sortBy": "publishedAt", "pageSize": 25]
    }
    
    public func populateRequest(queryParams: inout [String: Any]) {
        api.makeRequest(index: 0, params: &queryParams) { response in
            let data = JSON(response)
            self.parse(json: data)
        }
    }
    
    func parse(json: JSON) {
        var articles = [Article]()
        for result in json["articles"].arrayValue {
            let newArticle = Article()
            newArticle.title = result["title"].stringValue
            newArticle.description = result["description"].stringValue
            newArticle.url =  result["url"].stringValue
            newArticle.author = result["source"]["name"].stringValue
            newArticle.content = result["content"].stringValue
            newArticle.imageURL = result["urlToImage"].stringValue
            newArticle.publishedAt = result["publishedAt"].stringValue
            
            articles.append(newArticle)
        }

        mainArticles.allArticles = articles
        tableview.reloadData()
    }
    
    func dataFromFilter(topics: String, countries: String) {
        var queryParams = constructQueryParams(countries: countries, topics: topics)
        populateRequest(queryParams: &queryParams)
    }
    
    // MARK: - Filter Button
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        // Present the filter view controller on a navigation controller
        let layout = UICollectionViewFlowLayout()
        let filterView = FilterViewController(collectionViewLayout: layout)
        filterView.delegate = self

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
        detailVC.delegate = self
        detailVC.auth = mainArticles.allArticles[indexPath.row].author!
        detailVC.givenTitle = mainArticles.allArticles[indexPath.row].title
        detailVC.mainDes = mainArticles.allArticles[indexPath.row].description
        detailVC.link = mainArticles.allArticles[indexPath.row].url
        detailVC.image = mainArticles.allArticles[indexPath.row].imageURL
        
        self.add(detailVC)
        
        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        detailVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        detailVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        detailVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
//        detailVC.view.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.92).isActive = true
        viewToDim.isHidden = false
        //Style A
//        detailVC.providesPresentationContextTransitionStyle = true
//        detailVC.definesPresentationContext = true
//        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        detailVC.view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.9)
//
//        self.view.addSubview(detailVC.view)
//        self.addChild(detailVC)
//        detailVC.didMove(toParent: self)
//
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
    
    func saveSelectedArticles(article: Article) {
        let newArticle = SavedArticle()
        newArticle.author = article.author
       // newArticle.content = article.content
        newArticle.desc = article.description
        newArticle.imageURL = article.imageURL
      //  newArticle.publishedAt = article.publishedAt
        newArticle.title = article.title
        newArticle.url = article.url
    
        do{
            try realm.write {
                realm.add(newArticle)
            }
        } catch {
            print("Unable to write to realm db, \(error)")
        }
        
        
        
//        let jsonEncoder = JSONEncoder()
//
//        if let data = try? jsonEncoder.encode(savedArticles) {
//
//            let defaults = UserDefaults.standard
//            defaults.set(data, forKey: "SelectedArticles")
//        }
        
    }
    
//    func loadSelectedArticles() {
//
//        let defaults = UserDefaults.standard
//        if let data = defaults.object(forKey: "SelectedArticles") as? Data {
//
//            let jsonDecoder = JSONDecoder()
//
//            do {
//
//                savedArticles = try jsonDecoder.decode(ArticleStore.self, from: data)
//
//            } catch {
//
//                let ac = UIAlertController(title: "Load error", message: "Cound not load articles.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                present(ac, animated: true)
//            }
//        }
//
//    }
    
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

extension MainNewsController: ReadyToDismiss {
    func removeDim() {
        viewToDim.isHidden = true
    }
    
}
