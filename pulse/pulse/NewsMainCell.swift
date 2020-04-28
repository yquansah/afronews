//
//  NewsMainCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 8/17/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import Nuke

protocol DidTapCellButton {
    func didTapShareButton()
    func didTapSaveButton(author: String, description: String, mainImage: String, title: String, url: String)
}

class NewsMainCell: UITableViewCell {

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var publishedAt: UILabel!

    var delegate: DidTapCellButton?

    func updateCell(with article: Article) {
        author.text = article.author ?? "No Author"
        mainDescription.text = article.description
        country.text = article.country ?? "Unknown"
        if let url = URL(string: article.imageURL) {
            Nuke.loadImage(with: url, into: mainImage)
            print("Image loaded")
        }
    }
    
    func updateCell(with savedArticle: SavedArticle) {
        author.text = savedArticle.author ?? "No Author"
        mainDescription.text = savedArticle.desc
        country.text = "Ghana"
        if let url = URL(string: savedArticle.imageURL) {
            Nuke.loadImage(with: url, into: mainImage)
        }
    }

}
