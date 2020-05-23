//
//  ShiftCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class ShiftCell: UICollectionViewCell {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var labelMasuk: CustomLabel!
    @IBOutlet weak var labelKeluar: CustomLabel!
    @IBOutlet weak var labelMasukTitle: CustomLabel!
    @IBOutlet weak var labelKeluarTitle: CustomLabel!
    @IBOutlet weak var imageSelected: UIImageView!
    
    var data: ShiftItem? {
        didSet {
            if let _data = data {
                imageSelected.isHidden = !_data.isSelected
                labelName.text = _data.emp_name
                labelShift.text = _data.shift_name
                labelMasuk.text = _data.shift_start
                labelKeluar.text = _data.shift_end
                viewParent.backgroundColor = _data.isSelected ? UIColor.windowsBlue : UIColor.paleGreyTwo
                labelName.textColor = _data.isSelected ? UIColor.white : UIColor.dark
                labelShift.textColor = _data.isSelected ? UIColor.white : UIColor.dark
                labelMasukTitle.textColor = _data.isSelected ? UIColor.white : UIColor.dark
                labelKeluarTitle.textColor = _data.isSelected ? UIColor.white : UIColor.dark
                labelMasuk.textColor = _data.isSelected ? UIColor.white : UIColor.dark
                labelKeluar.textColor = _data.isSelected ? UIColor.white : UIColor.dark
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        viewParent.giveBorder(1, UIColor.windowsBlue)
    }
}
