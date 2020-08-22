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
    @IBOutlet weak var readButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 12
        self.view.layer.masksToBounds = true
        readButton.layer.cornerRadius = 5
    }
    
    func updateDetailView() {
        mainTitle.text = givenTitle
        mainDescription.text = mainDes
        author.text = auth
        if let url = URL(string: image) {
            Nuke.loadImage(with: url, into: mainImage)
        }
    }
    
    @IBAction func redirToSourceButton(_ sender: UIButton) {
        PulseAnalytics.logClickedReadMoreButton() // Log firebase that this button has been clicked
        
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
        PulseAnalytics.logSaveArticle() // Log that an article has been saved
        self.saveArticle(article: article!)
    }
    
}
