//
//  RiwayatTukarShiftCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class RiwayatTukarShiftCell: BaseCollectionViewCell {

    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDate: CustomLabel!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var labelTukarShiftDate: CustomLabel!

    var data: RiwayatTukarShiftItem? {
        didSet {
            if let _data = data {
                imageStatus.image = UIImage(named: getImageStatus(status: "\(_data.exchange_status ?? 0)"))
                labelStatus.text = getStringStatus(status: "\(_data.exchange_status ?? 0)")
                labelNomer.text = _data.exchange_number
                labelDate.text = _data.exchange_request_date
                labelContent.text = "\("exchange_shift_request".localize()) \(_data.exchange_emp_name ?? "")."
                labelTukarShiftDate.text = _data.exchange_date_shift_name
            }
        }
    }
    
    private func getStringStatus(status: String) -> String {
        if status == "0" {
            return "saved".localize()
        } else if status == "1" {
            return "submitted".localize()
        } else if status == "2" {
            return "rejected".localize()
        } else if status == "3" {
            return "approved".localize()
        } else {
            return "canceled".localize()
        }
    }
    
    private func getImageStatus(status: String) -> String {
        if status == "0" {
            return "24GadgetsFloppy"
        } else if status == "1" {
            return "24BasicCircleChecked"
        } else if status == "2" {
            return "24BasicCircleX"
        } else if status == "3" {
            return "24BasicCircleGreen"
        } else {
            return "24BasicCanceled"
        }
    }
    
}
