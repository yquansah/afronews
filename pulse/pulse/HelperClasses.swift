//
//  HelperClasses.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 6/2/20.
//  Copyright © 2020 bdt. All rights reserved.
//

import UIKit

class GradientView: UIView {
    // This class is used for UIViews with gradients
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear]
    }
}
