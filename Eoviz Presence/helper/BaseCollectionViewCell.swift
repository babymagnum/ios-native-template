//
//  BaseCollectionViewCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    lazy var screenWidth: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    lazy var screenHeight: CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
}
