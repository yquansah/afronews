//
//  FilterViewController.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 11/16/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class FilterViewController: UICollectionViewController {
    
    /*
     This is responsible for filter view. It will help you select the country and topics
     */
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .blue
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        title = "Filter"
        
        
    }
    
    private func setupView() {
        
    }
    

}
