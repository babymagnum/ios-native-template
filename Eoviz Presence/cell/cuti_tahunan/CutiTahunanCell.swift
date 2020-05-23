//
//  CutiTahunanCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class CutiTahunanCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var switchApproval: UISwitch!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var viewParent: UIView!
    
    var data: CutiTahunanItem? {
        didSet {
            if let _data = data {
                labelDate.text = _data.date
                switchApproval.setOn(_data.isApprove, animated: true)
                
                if _data.isFirst && _data.isOnlyOne {
                    viewParent.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 15)
                    viewDivider.isHidden = true
                } else if _data.isFirst {
                    viewParent.roundCorners([.topLeft, .topRight], radius: 15)
                    viewDivider.isHidden = false
                } else if _data.isLast {
                    viewParent.roundCorners([.bottomLeft, .bottomRight], radius: 15)
                    viewDivider.isHidden = true
                } else {
                    viewParent.roundCorners([.bottomLeft, .bottomRight, .topRight, .topLeft], radius: 0)
                    viewDivider.isHidden = false
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if let _data = self.data {
                if _data.isFirst && _data.isOnlyOne {
                    self.viewParent.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 15)
                    self.viewDivider.isHidden = true
                } else if _data.isFirst {
                    self.viewParent.roundCorners([.topLeft, .topRight], radius: 15)
                    self.viewDivider.isHidden = false
                } else if _data.isLast {
                    self.viewParent.roundCorners([.bottomLeft, .bottomRight], radius: 15)
                    self.viewDivider.isHidden = true
                } else {
                    self.viewParent.roundCorners([.bottomLeft, .bottomRight, .topRight, .topLeft], radius: 0)
                    self.viewDivider.isHidden = false
                }
            }
        }
    }
    
}
