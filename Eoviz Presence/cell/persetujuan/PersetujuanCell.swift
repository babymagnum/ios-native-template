//
//  PersetujuanCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class PersetujuanCell: BaseCollectionViewCell {

    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewDot: CustomView!
    @IBOutlet weak var viewDotWidth: NSLayoutConstraint!
    @IBOutlet weak var viewDotLeftMargin: NSLayoutConstraint!
    
    var data: ExchangeShiftApprovalItem? {
        didSet {
            if let _data = data {
                imageUser.loadUrl(_data.photo ?? "")
                labelDate.text = _data.request_date
                labelContent.text = _data.content
                viewDot.isHidden = false
                viewDotWidth.constant = false ? 0 : 8
                viewDotLeftMargin.constant = false ? 0 : 10
                
                labelContent.font = false ? UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize()) : UIFont(name: "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())
            }
        }
    }
    
}
