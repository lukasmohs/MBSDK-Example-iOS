//
//  badgeCard.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//


import Foundation
import UIKit

class BadgeCard: UIView {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "BadgeCard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

