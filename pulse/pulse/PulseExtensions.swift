//
//  PulseExtensions.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 5/12/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit

/*
 This file is used to create all the necessary extensions
 */

extension UIViewController {
    
    func saveArticle(article: Article) {
        // This function is used to save any article from any view controller
        let newArticle = SavedArticle()
        newArticle.author = article.author!
        newArticle.country = article.country!
        newArticle.desc = article.description
        newArticle.imageURL = article.imageURL
        newArticle.publishedAt = article.publishedAt
        newArticle.title = article.title
        newArticle.url = article.url
         
         let queryString = "author = '\(article.author!)' AND title = '\(article.title)'"
         
         let queryArticles = Storage.loadArticles().filter(queryString)
         
         var alert: UIAlertController
         if queryArticles.count == 0 {
             Storage.saveArticle(article: newArticle)
             alert = UIAlertController(title: "Success", message: "Article was successfully saved", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         } else {
             alert = UIAlertController(title: "Error", message: "Article has already been saved", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
    }
    
    func shareArticle(article: Article) {
        let shareText = "Check this news article out, from Pulse."
        let shareLink = article.url
        let objectsToShare = [shareText, shareLink] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
