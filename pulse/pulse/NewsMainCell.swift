//
//  NewsMainCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 8/17/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import Nuke

class NewsMainCell: UITableViewCell {

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var publishedAt: UILabel!
    
    func updateCell(with article: Article) {
        author.text = article.author ?? "No Author"
        mainDescription.text = article.description
        country.text = article.country ?? "Ghana"
        if let url = URL(string: article.imageURL) {
            Nuke.loadImage(with: url, into: mainImage)
        }
    }
}
