//
//  TopicCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 12/23/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class TopicCellView: UICollectionViewCell {
    
    /*
     This is cell is the collection view that displays the topics for users to select
     */
    
    // Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let topicCellID = "topicCell"
    
    let topics = ["Business", "Entertainment", "Politics", "Sports", "Technology"]
    
    var finalData = [FilterData]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: topicCellID)
        
        // setup array
        topics.forEach{finalData.append(FilterData(itemName: $0))}
    }
}

// MARK:- Datasource
extension TopicCellView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        finalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topicCellID, for: indexPath) as! TopicCell
        cell.updateCell(with: finalData[indexPath.row])
        
        if finalData[indexPath.row].selectedState {
            cell.isSelected = false
            cell.viewToDim.isHidden = false
        }
        return cell
    }
    
    
}

// MARK:- Delegate
extension TopicCellView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - 16)/5
        let height = frame.height - 32 // - 16 kept complaining
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TopicCell
        
        finalData[indexPath.row].selectedState = !finalData[indexPath.row].selectedState
        cell.viewToDim.isHidden = finalData[indexPath.row].selectedState ? false : true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TopicCell

        finalData[indexPath.row].selectedState = !finalData[indexPath.row].selectedState
        cell.viewToDim.isHidden = finalData[indexPath.row].selectedState ? false : true
    }
}
