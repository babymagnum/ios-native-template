//
//  NotifikasiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class NotifikasiCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelTitle: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewRedDot: CustomView!
    
    var data: NotificationItem? {
        didSet {
            if let _data = data {
                labelDate.text = _data.notification_date
                labelTitle.text = _data.notification_title
                labelContent.text = _data.notification_content
                
                viewRedDot.isHidden = _data.notification_is_read ?? 0 == 1 ? true : false
                labelTitle.font = UIFont(name: _data.notification_is_read ?? 0 == 1 ? "Poppins-Regular" : "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())
                labelContent.font = UIFont(name: _data.notification_is_read ?? 0 == 1 ? "Poppins-Regular" : "Poppins-SemiBold", size: 11 + PublicFunction.dynamicSize())
            }
        }
    }

}
