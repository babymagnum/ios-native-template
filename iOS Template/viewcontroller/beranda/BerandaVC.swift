//
//  BerandaVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD
import GoogleMaps

class BerandaVC: BaseViewController {
    
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var viewCornerParent: CustomView!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var labelPresenceStatus: CustomLabel!
    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var collectionData: UICollectionView!
    @IBOutlet weak var viewPresensi: UIView!
    @IBOutlet weak var viewTukarShift: UIView!
    @IBOutlet weak var viewIzinCuti: UIView!
    @IBOutlet weak var viewJamKerja: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
