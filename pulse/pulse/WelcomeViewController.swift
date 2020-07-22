//
//  WelcomeViewController.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 6/2/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    /*
    This VC is used to to show a welcome message the first time users open the app
    */
    
    // MARK: - Properties
    weak var firstTimeDelegate: FirstTimeUseCase?
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 7
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        view.addSubview(mainView)
        
        mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        mainView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        mainView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        mainView.addSubview(textLabel)
        mainView.addSubview(nextButton)
        
        textLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10).isActive = true
        textLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -8).isActive = true
        
        nextButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        
        // Get text
        if let welcomePath = Bundle.main.path(forResource: "welcome", ofType: ".txt") {
            if let welcomeText = try? String(contentsOfFile: welcomePath) {
                textLabel.text = welcomeText
            }
        }
    }
    
    // MARK: - Objc
    @objc private func nextButtonAction(sender: UIButton) {
        firstTimeDelegate?.dismissWelcomeView(sender: self)
    }
    
}
