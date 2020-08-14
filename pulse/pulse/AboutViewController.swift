//
//  AboutViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 5/1/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBAction func feedbackBtnTapped(_ sender: UIButton) {
        aboutAlert()
    }

    @IBAction func reviewBtnTapped(_ sender: UIButton) {
        aboutAlert()
    }

    func aboutAlert() {
        let ac = UIAlertController(title: "Not Available", message: "These options are not available in the beta stage.", preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
        present(ac, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.layer.cornerRadius = 5
        feedbackButton.layer.cornerRadius = 5
    }

}
