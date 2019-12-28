//
//  TopicCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 12/23/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class TopicCell: UICollectionViewCell {
    
    /*
     This is cell is used to display the Topics for users to select
     */
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "obama")
        iv.contentMode = .center
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    var viewToDim: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        uiView.isHidden = true
        return uiView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(viewToDim)
        addSubview(imageView)
        addSubview(nameLabel)
        
        viewToDim.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        let nameHeight = frame.height - frame.width - 1
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width, width: frame.width, height: nameHeight)
    }
    
    func updateCell(with name: FilterData) {
        imageView.image = UIImage(named: name.itemName)
        nameLabel.text = name.itemName
    }
}
