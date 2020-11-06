//
//  AboutViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 5/1/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var productURL = URL(string: "https://apps.apple.com/us/app/id1511288350")!

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBAction func feedbackBtnTapped(_ sender: UIButton) {
        sendFeedBack()
    }

    @IBAction func reviewBtnTapped(_ sender: UIButton) {
        writeReview()
    }

    func aboutAlert() {
        let ac = UIAlertController(title: "Not Available", message: "These options are not available in the beta stage.", preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)

    }

    func writeReview() {
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)

        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]

        guard let writeReviewURL = components?.url else { return }

        print(writeReviewURL)
        UIApplication.shared.open(writeReviewURL)

    }

    func sendFeedBack() {

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Pulse Africa App - Feedback")
            mail.setToRecipients(["kaydabigames@gmail.com"])

            present(mail, animated: true)
        } else {
            let ac = UIAlertController(title: "Ohh oh", message: "Can't send mail on this phone", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))

            present(ac, animated: true)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.layer.cornerRadius = 5
        feedbackButton.layer.cornerRadius = 5
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
