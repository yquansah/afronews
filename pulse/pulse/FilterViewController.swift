//
//  FilterViewController.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 11/16/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class FilterViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /*
     This is responsible for filter view. It will help you select the country and topics
     */
    // Properties
    private let topicCellViewID = "topicViewCell"
    private let countryCellViewID = "countryCellView"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    private func setupView() {
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        title = "Filter"
        
        // Bar Buttons
        let leftBarButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clearButton))
        leftBarButton.tintColor = .white
        
        let rightBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        rightBarButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
        // Cells
        collectionView.register(TopicCellView.self, forCellWithReuseIdentifier: topicCellViewID)
        collectionView.register(CountriesCellView.self, forCellWithReuseIdentifier: countryCellViewID)
    }
    
    @objc private func clearButton() {
//        collectionView.reloadData()
        collectionView.indexPathsForSelectedItems?.forEach { self.collectionView.deselectItem(at: $0, animated: false)}
    }
    
    @objc private func doneButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK:- Datasource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topicCellViewID, for: indexPath) as! TopicCellView
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: countryCellViewID, for: indexPath) as! CountriesCellView
        return cell
    }
    
    // MARK:- Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let firstCellHeight = (view.frame.width/5) + 50 // the width of the topic cells (not including 16 for the edge) + 50
        let secondCellHeight = view.frame.height - firstCellHeight
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: firstCellHeight)
        }
        return CGSize(width: view.frame.width, height: secondCellHeight)
    }
}

