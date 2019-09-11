//
//  RecommendationView.swift
//  MBMobileExample
//
//  Created by Dimitri Tyan on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit

class RecommendationView: UIView {
    
    @IBOutlet weak var recommendationBackgroundView: UIView!
    @IBOutlet weak var recommendationText: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "RecommendationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
