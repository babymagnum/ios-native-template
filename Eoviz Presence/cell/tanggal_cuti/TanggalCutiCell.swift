//
//  TanggalCutiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class TanggalCutiCell: UICollectionViewCell {

    @IBOutlet weak var viewDateParent: UIView!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var viewDivider: UIView!
    
    var data: TanggalCutiItem? {
        didSet {
            if let _data = data {
                labelDate.text = _data.date
                
                if _data.isFirst && _data.isOnlyOne {
                    viewDateParent.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 15)
                    viewDivider.isHidden = true
                } else if _data.isFirst {
                    viewDateParent.roundCorners([.topLeft, .topRight], radius: 15)
                    viewDivider.isHidden = false
                } else if _data.isLast {
                    viewDateParent.roundCorners([.bottomLeft, .bottomRight], radius: 15)
                    viewDivider.isHidden = true
                } else {
                    viewDateParent.roundCorners([.bottomLeft, .bottomRight, .topRight, .topLeft], radius: 0)
                    viewDivider.isHidden = false
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let _data = data {
            
            if _data.isFirst && _data.isOnlyOne {
                viewDateParent.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 15)
                viewDivider.isHidden = true
            } else if _data.isFirst {
                viewDateParent.roundCorners([.topLeft, .topRight], radius: 15)
                viewDivider.isHidden = false
            } else if _data.isLast {
                viewDateParent.roundCorners([.bottomLeft, .bottomRight], radius: 15)
                viewDivider.isHidden = true
            } else {
                viewDateParent.roundCorners([.bottomLeft, .bottomRight, .topRight, .topLeft], radius: 0)
                viewDivider.isHidden = false
            }
        }
    }
}
