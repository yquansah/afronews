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
        
        //Load saved filter if available.
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "topics") != nil || defaults.object(forKey: "countries") != nil {
            loadFilter()
        }
        
        // Dimming
        view.addSubview(viewToDim)
        viewToDim.frame = view.frame
    }
    
    private func constructQueryParams(countries: String, topics: String) -> [String: Any] {
        return ["countries": countries, "topics": topics]
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

            print("Image URL after parsing: \(newArticle.imageURL)")
            
            articles.append(newArticle)
        }

        mainArticles.allArticles = articles
        tableview.reloadData()
    }
    // MARK: - Done pressed delegate function
    func dataFromFilter(topics: String, countries: String) {
        var queryParams = constructQueryParams(countries: countries, topics: topics)
        populateRequest(queryParams: &queryParams)
        
        saveFilter(topics: topics, countries: countries)
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
        cell.delegate = self
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
        viewToDim.isHidden = false

        detailVC.updateDetailView()
        
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
    
        do {
            try realm.write {
                realm.add(newArticle)
            }
        } catch {
            print("Unable to write to realm db, \(error)")
        }
        
    }

    func saveFilter(topics: String, countries: String) {
        let defaults = UserDefaults.standard
        defaults.set(topics, forKey: "topics")
        defaults.set(countries, forKey: "countries")
        defaults.set(true, forKey: "filterSet")
        
    }
    
    func loadFilter() {
        let defaults = UserDefaults.standard
        
        let topics = defaults.object(forKey: "topics") as! String
        let countries = defaults.object(forKey: "countries") as! String
        
        var queryParams = constructQueryParams(countries: countries, topics: topics)
        populateRequest(queryParams: &queryParams)
        
    }
}
// MARK: - Child view manipulation functions
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

// MARK: - Dismiss protocol
extension MainNewsController: ReadyToDismiss {
    func removeDim() {
        viewToDim.isHidden = true
    }
    
}

extension MainNewsController: DidTapCellButton {
    func didTapSaveButton(author: String, description: String, mainImage: String, title: String, url: String) {
        let newArticle = SavedArticle()
                    newArticle.author = author
               //     newArticle.content = article.content
                    newArticle.desc = description
                    newArticle.imageURL = mainImage
               //     newArticle.publishedAt = article.publishedAt
                    newArticle.title = title
                    newArticle.url = url

                    do {
                        try realm.write {
                            realm.add(newArticle)
                        }
                    } catch {
                        print("Unable to write to realm db, \(error)")
                    }
    }

    func didTapShareButton() {
        let shareText = "Check this news article out, from Pulse."
        let shareLink = link
        let objectsToShare = [shareText, shareLink] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true)
    }

}
