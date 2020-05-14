//
//  WebViewController.swift
//  pulse
//
//  Created by Adnan Abdulai on 5/10/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var urlString: String!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView

        guard let url = URL(string: urlString) else { return }

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareTapped))

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    @objc func shareTapped() {
        let shareText = "Check this news article out, from Pulse."
        let shareLink: String =  String(urlString)
        let objectsToShare = [shareText, shareLink]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        present(activityVC, animated: true)    }

}
