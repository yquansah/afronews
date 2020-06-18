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
import WebKit

class MainNewsController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    // MARK: - Define variables
    private var mainArticles = ArticleStore()
    private var savedArticle = SavedArticle()
    private var api: API!

  //  var webView: WKWebView!
    
    private lazy var backgroundLabel: UILabel = {
        // This label is used to inform the user if there is no result
        let label = UILabel()
        label.center = self.view.center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    private lazy var indicateActivity: UIActivityIndicatorView = {
        // Activity indicator to show user that there is searching going on
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        
       return indicator
    }()
    
    lazy var viewToDim: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        uiView.isHidden = true
        
        return uiView
    }()
    
    lazy private var pullRefresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .lightGray
        refresh.addTarget(self, action: #selector(pullDownAction), for: .valueChanged)
        return refresh
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupView()
        
        api = API()
        //Load saved filter if available.
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "topics") != nil || defaults.object(forKey: "countries") != nil {
            loadFilter()
        }
        
    }
    
    private func setupView() {
        view.addSubview(backgroundLabel)
        view.addSubview(indicateActivity)
        // Dimming
        view.addSubview(viewToDim)
        // Set constrains and frame for views tha need it
        backgroundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 8).isActive = true
        backgroundLabel.heightAnchor.constraint(equalToConstant: 500).isActive = true
        viewToDim.frame = view.frame
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.refreshControl = pullRefresh
    }
    
    private func constructQueryParams(countries: String, topics: String) -> [String: Any] {
        return ["countries": countries, "topics": topics]
    }
    
    public func populateRequest(queryParams: inout [String: Any]) {
        indicateActivity.startAnimating()
        api.makeRequest(index: 0, params: &queryParams) { [weak self] response in
            let data = JSON(response)
            self?.parse(json: data)
        }
    }
    
    func parse(json: JSON) {
        var articles = [Article]()
        
        let country: String = json["country"].stringValue
        for result in json["articles"].arrayValue {
            let newArticle = Article()
            newArticle.country = country
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
        // Stop spinner, check if empty and either reload or show text to user
        indicateActivity.stopAnimating()
        
        if articles.isEmpty {
            tableview.isHidden = true
            backgroundLabel.text = "There is no information available, please select another Country and Topic by clicking the Filter button"
            return
        }
        
        mainArticles.allArticles = articles
        backgroundLabel.text = ""
        tableview.isHidden = false
        tableview.reloadData()
    }
    
    // MARK: - Pull Down Refresh
    @objc private func pullDownAction() {
        loadFilter()
        pullRefresh.endRefreshing()
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

// MARK: - Tableview Delegate and Datasource
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
        
        detailVC.delegate = self
        detailVC.article = mainArticles.allArticles[indexPath.row]
        detailVC.auth = mainArticles.allArticles[indexPath.row].author!
        detailVC.givenTitle = mainArticles.allArticles[indexPath.row].title
        detailVC.mainDes = mainArticles.allArticles[indexPath.row].description
        detailVC.link = mainArticles.allArticles[indexPath.row].url
        detailVC.image = mainArticles.allArticles[indexPath.row].imageURL
        
        self.add(detailVC)
        
        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        detailVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        detailVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        detailVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        viewToDim.isHidden = false

        detailVC.updateDetailView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176 // This is because the images are 140 + 18  at the top margin and + 18 at the bottom margin
    }
    
    // MARK: - Persistency functions

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
    func displayWebView(with url: String) {
        let webview = WebViewController()
        webview.urlString = url
        navigationController?.pushViewController(webview, animated: true)

    }

    func removeDim() {
        viewToDim.isHidden = true
    }
    
}

// MARK: - DidTapCellButton functions
extension MainNewsController: DidTapCellButton {
    
    func didTapShareButton(article: Article) {
        self.shareArticle(article: article)
    }
    
    func didTapSaveButton(article: Article) {
        self.saveArticle(article: article)
    }

}

// MARK: - Done pressed delegate function
extension MainNewsController: DonePressed {
    
    func dataFromFilter(topics: String, countries: String) {
        
        var queryParams = constructQueryParams(countries: countries, topics: topics)
        populateRequest(queryParams: &queryParams)
        saveFilter(topics: topics, countries: countries)
        // Scroll tableview back to the top
        tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
