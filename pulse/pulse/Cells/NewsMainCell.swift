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
    func didTapShareButton(article: Article)
    func didTapSaveButton(article: Article)
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
    private var cellArticle: Article?
    
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
        
        cellArticle = article
        
        author.text = article.author ?? "No Author"
        mainDescription.text = article.description
        country.text = article.country ?? "Unknown"
        if let url = URL(string: article.imageURL) {
            Nuke.loadImage(with: url, into: mainImage)
        }

        publishedAt.text = formatDate(with: article.publishedAt)

    }
    
    func updateCell(with savedArticle: SavedArticle) {
        // In order pass an Article object to the share protocol for the SaveVC, creating and Article object this SavedArticle. As we care about is the url
        cellArticle = Article()
        cellArticle?.url = savedArticle.url
        
        author.text = savedArticle.author ?? "No Author"
        mainDescription.text = savedArticle.desc
        country.text = savedArticle.country
        if let url = URL(string: savedArticle.imageURL) {
            Nuke.loadImage(with: url, into: mainImage)
        }
        publishedAt.text = formatDate(with: savedArticle.publishedAt)
    }
    
    @objc private func shareRecognizer(gesture: UIGestureRecognizer) {
        guard let article = cellArticle else {
            print("Error NewsMainCell - No articles to share")
            return
        }
        delegate?.didTapShareButton(article: article)

    }
    
    @objc private func saveRecognizer(gesture: UIGestureRecognizer) {
        guard let article = cellArticle else {
            print("Error NewsMainCell - No articles to save")
            return
        }
        delegate?.didTapSaveButton(article: article)

    }

    func formatDate(with publishedDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let publishedAt = dateFormatter.date(from: publishedDate) else { return "24h ago" }
        print("This is the raw date: \(publishedDate)")
        print(publishedAt)
        let interval = DateInterval(start: publishedAt, end: Date())
        let duration = Int(interval.duration) / 3600

        switch duration {
        case 0..<1:
            return "mins ago"
        case 1..<24:
            return "\(duration)h ago"
        case 24...:
            return "\(duration / 24)d ago"
        default:
            return "24h ago"
        }

    }

}
