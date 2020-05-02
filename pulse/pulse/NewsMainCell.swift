//
//  NewsMainCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 8/17/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import Nuke

protocol DidTapCellButton: class {
    func didTapShareButton()
    func didTapSaveButton(author: String, description: String, mainImage: String, title: String, url: String)
}

class NewsMainCell: UITableViewCell {

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var publishedAt: UILabel!
    @IBOutlet weak var saveButton: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    
    weak var delegate: DidTapCellButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    private func setupCell() {
        let share = UITapGestureRecognizer(target: self, action: #selector(shareRecognizer(gesture:)))
        shareButton.addGestureRecognizer(share)
        shareButton.isUserInteractionEnabled = true
        
        let save = UITapGestureRecognizer(target: self, action: #selector(saveRecognizer(gesture:)))
        saveButton.addGestureRecognizer(save)
        saveButton.isUserInteractionEnabled = true
    }

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
    
    @objc private func shareRecognizer(gesture: UIGestureRecognizer) {
        delegate?.didTapShareButton()
    }
    
    @objc private func saveRecognizer(gesture: UIGestureRecognizer) {
        print("Svae tappeddd")
    }

}
