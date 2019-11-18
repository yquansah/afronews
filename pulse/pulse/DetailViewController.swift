//
//  DetailViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 11/16/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var image: String = ""
    var givenTitle: String = ""
    var mainDes: String = ""
    var auth: String = ""

    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var mainTitle: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    @IBOutlet private weak var author: UILabel!

    func updateDetailView() {
        mainTitle.text = givenTitle
        mainDescription.text = mainDes
        author.text = auth

    }

    @IBAction func redirToSourceButton(_ sender: UIButton) {

    }

}
