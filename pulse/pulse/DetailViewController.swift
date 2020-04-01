//
//  DetailViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 11/16/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import RealmSwift
import Nuke

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    var image: String = ""
    var givenTitle: String = ""
    var mainDes: String = ""
    var auth: String = ""
    var link: String = ""

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var mainTitle: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    @IBOutlet private weak var author: UILabel!

    func updateDetailView() {
        mainTitle.text = givenTitle
        mainDescription.text = mainDes
        author.text = auth
        if let url = URL(string: image) {
            Nuke.loadImage(with: url, into: mainImage)
        }
    }

    @IBAction func redirToSourceButton(_ sender: UIButton) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.remove()

    }

    @IBAction func shareButton(_ sender: UIButton) {
        let shareText = "Check this news article out, from Pulse."
        let shareLink = link
        let objectsToShare = [shareText, shareLink]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @IBAction func saveButton(_ sender: UIButton) {
        let newArticle = SavedArticle()
            newArticle.author = auth
       //     newArticle.content = article.content
            newArticle.desc = mainDes
            newArticle.imageURL = image
       //     newArticle.publishedAt = article.publishedAt
            newArticle.title = givenTitle
            newArticle.url = link
        
            do{
                try realm.write {
                    realm.add(newArticle)
                }
            } catch {
                print("Unable to write to realm db, \(error)")
            }
            
    }

}
