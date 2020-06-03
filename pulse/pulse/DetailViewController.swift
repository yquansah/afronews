//
//  DetailViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 11/16/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    var image: String = ""
    var givenTitle: String = ""
    var mainDes: String = ""
    var auth: String = ""
    var link: String = ""
    
    weak var delegate: ReadyToDismiss?
    var article: Article?

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
        
            self.remove()
        //    UIApplication.shared.open(url)
            delegate?.displayWebView(with: link)
            delegate?.removeDim()

    }
    @IBAction func dismissView(_ sender: UIButton) {
        self.remove()
        // Alert parent so the dimmed background is removed
        delegate?.removeDim()
    }

    @IBAction func shareButton(_ sender: UIButton) {
        self.shareArticle(article: article!)
    }

    @IBAction func saveButton(_ sender: UIButton) {
        self.saveArticle(article: article!)
    }

}
