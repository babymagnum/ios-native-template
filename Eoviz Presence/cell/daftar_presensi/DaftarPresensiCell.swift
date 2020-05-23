//
//  DaftarPresensiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DaftarPresensiCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var buttonStatus: CustomButton!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamMasukReal: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var labelJamKeluarReal: CustomLabel!
    @IBOutlet weak var labelShiftName: CustomLabel!
    @IBOutlet weak var viewParent: CustomView!
    
    var data: DaftarPresensiItem? {
        didSet {
            if let _data = data {
                labelDate.text = _data.presence_date
                buttonStatus.setTitle(_data.prestype_name ?? "" == "" ? "    -    " : _data.prestype_name, for: .normal)
                buttonStatus.backgroundColor = UIColor.init(hexString: (_data.prestype_bg_color ?? "" == "" ? "#9CCC65" : _data.prestype_bg_color ?? "").substring(fromIndex: 1))
                labelJamMasuk.text = _data.presence_shift_start
                labelJamMasukReal.text = _data.presence_in
                labelJamKeluar.text = _data.presence_shift_end
                labelJamKeluarReal.text = _data.presence_out
                labelShiftName.text = _data.presence_shift_name?.capitalizingFirstLetter()
                
                let today = PublicFunction.getStringDate(pattern: "EEEE, dd MMMM yyyy")
                let isBordered = today == _data.presence_date ?? ""
                viewParent.giveBorder(isBordered ? 2 : 0, UIColor.windowsBlue)
            }
        }
    }
}
