//
//  RiwayatIzinCutiCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class RiwayatIzinCutiCell: UICollectionViewCell {

    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelType: CustomLabel!
    @IBOutlet weak var labelCutiDate: CustomLabel!

    var data: RiwayatIzinCutiItem? {
        didSet {
            if let _data = data {
                imageStatus.image = UIImage(named: getImage(status: _data.permission_status ?? 0))
                labelStatus.text = getStatusString(status: _data.permission_status ?? 0)
                labelNomer.text = _data.permission_number
                labelDate.text = _data.permission_date_request
                labelType.text = _data.permission_reason
                labelCutiDate.text = _data.date
            }
        }
    }
    
    private func getStatusString(status: Int) -> String {
        if status == 0 {
            return "saved".localize()
        } else if status == 1 {
            return "submitted".localize()
        } else if status == 2 {
            return "rejected".localize()
        } else if status == 3 {
            return "approved".localize()
        } else {
            return "canceled".localize()
        }
    }
    
    private func getImage(status: Int) -> String {
        if status == 0 {
            return "24GadgetsFloppy"
        } else if status == 1 {
            return "24BasicCircleChecked"
        } else if status == 2 {
            return "24BasicCircleX"
        } else if status == 3 {
            return "24BasicCircleGreen"
        } else {
            return "24BasicCanceled"
        }
    }

}
