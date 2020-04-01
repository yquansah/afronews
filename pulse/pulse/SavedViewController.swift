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
    
    
    @IBOutlet weak var tableview: UITableView!
    
    // Define variables
    let realm = try! Realm()
//    private var savedArticle = SavedArticle()
//    private var api: API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    func load() {
        articles = realm.objects(SavedArticle.self)
        tableview.reloadData()
    }
    
    
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedPulseCell", for: indexPath) as! NewsMainCell
        cell.updateCell(with: articles![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: articles![indexPath.row].url) {
            UIApplication.shared.open(url)
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let article = articles?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(article)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } catch {
                    print("Error with deleting article, \(error)")
                }
                
            }
            
            
        }
    }
    
}
