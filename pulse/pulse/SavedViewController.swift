//
//  SavedViewController.swift
//  pulse
//
//  Created by Admin on 3/29/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit
import RealmSwift

class SavedViewController: UIViewController {
    
    var articles: Results<SavedArticle>?

    var savedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your saved articles will appear here."

        return label
    }()

    @IBOutlet weak var tableview: UITableView!
    
 // Define variables
//    private var savedArticle = SavedArticle()
//    private var api: API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        setupView()

        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    func load() {
        articles = Storage.loadArticles()

        tableview.reloadData()

        if let articleCount = articles?.count {
            if articleCount > 0 {
                savedLabel.isHidden = true
            } else {
                savedLabel.isHidden = false
            }
        }

//        if articles!.count > 0 {
//            savedLabel.isHidden = true
//        } else {
//            savedLabel.isHidden = false
//        }
    }

    private func setupView() {

        view.addSubview(savedLabel)

        savedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        savedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        savedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        savedLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true

    }

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedPulseCell", for: indexPath) as! NewsMainCell
        cell.updateCell(with: articles![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = articles![indexPath.row].url
        let webview = WebViewController()
        webview.urlString = url
        navigationController?.pushViewController(webview, animated: true)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let article = articles?[indexPath.row] {
                Storage.deleteArticle(article: article)
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176 // This is because the images are 140 + 18  at the top margin and + 18 at the bottom margin
    }
    
}

// MARK: - DidTapCellButton functions
extension SavedViewController: DidTapCellButton {
    
    func didTapShareButton(article: Article) {
        self.shareArticle(article: article)
    }
    
    func didTapSaveButton(article: Article) {
        // do nothing since we don't want to save in this view
    }

}
