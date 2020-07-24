//
//  TopicCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 12/23/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class CountryCell: UICollectionViewCell {
    
    /*
     This is cell is used to display the Countries for users to select
     */
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "obama")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Cameroon"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    var viewToDim: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.systemGray
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
        
        let imageHeight = frame.width * (2/3)
        let labelHeight = frame.width * (1/3)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: imageHeight)
        nameLabel.frame = CGRect(x: 0, y: imageHeight, width: frame.width, height: labelHeight)
    }
    
    func updateCell(with name: FilterData) {
        imageView.image = UIImage(named: name.itemName)
        nameLabel.text = name.itemName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewToDim.isHidden = true
    }
}
