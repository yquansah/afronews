//
//  TopicCell.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 12/23/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit

class CountriesCellView: UICollectionViewCell {
    
    /*
     This is cell is the collection view that displays the topics for users to select
     */
    
    // Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let countryCellID = "countryCell"
    
//    let countries = ["Algeria", "Angola", "Benin", "Botswana", "Burkina Faso", "Burundi", "C.A.R", "Cameroon", "Cape Verde", "Chad", "Comoros", "Congo", "D.R.C", "Djibouti", "Egypt", "Equatorial Guinea", "Eritrea", "Eswatini", "Ethiopia", "Gabon", "Ghana", "Guinea-Bissau", "Guinea", "Ivory Coast", "Kenya", "Lesotho", "Liberia", "Libya", "Madagascar", "Malawi", "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", "Namibia", "Niger", "Nigeria", "Rwanda", "São Tomé and Príncipe", "Seychelles", "Sierra Leone", "Somalia", "South Africa", "Sudan", "Tanzania", "The Gambia", "Togo", "Tunisia", "Uganda", "Western Sahara", "Zambia", "Zimbabwe"]
    
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
        
        collectionView.register(CountryCell.self, forCellWithReuseIdentifier: countryCellID)
        collectionView.allowsMultipleSelection = true
        
        // setup array
        if let countriesPath = Bundle.main.path(forResource: "countries", ofType: ".txt") {
            if let countriesFileContents = try? String(contentsOfFile: countriesPath) {
                let countries = countriesFileContents.components(separatedBy: ", ")
                countries.forEach {finalData.append(FilterData(itemName: $0))}
            }
        }

    }
}

// MARK:- Datasource
extension CountriesCellView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        finalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: countryCellID, for: indexPath) as! CountryCell
        cell.updateCell(with: finalData[indexPath.row])
        
        if finalData[indexPath.row].selectedState {
//            cell.isSelected = false
            cell.viewToDim.isHidden = false
        }
        return cell
    }
    
    
}

// MARK:- Delegate
extension CountriesCellView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - 16)/5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCell
        
        finalData[indexPath.row].selectedState = !finalData[indexPath.row].selectedState
        cell.viewToDim.isHidden = finalData[indexPath.row].selectedState ? false : true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CountryCell
        
        finalData[indexPath.row].selectedState = !finalData[indexPath.row].selectedState
        cell.viewToDim.isHidden = finalData[indexPath.row].selectedState ? false : true
        
    }
}
