//
//  GradientView.swift
//  MBMobileExample
//
//  Created by Dimitri Tyan on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.init(white: 1, alpha: 0).cgColor
        ]
        backgroundColor = UIColor.clear
    }
}
