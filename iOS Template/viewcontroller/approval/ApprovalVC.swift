//
//  ApprovalVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class ApprovalVC: BaseViewController {

    @IBOutlet weak var buttonTukarShift: CustomButton!
    @IBOutlet weak var buttonIzinCuti: CustomButton!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var collectionPersetujuan: UICollectionView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
