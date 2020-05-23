//
//  ProfileVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift
import SVProgressHUD
import Toast_Swift

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var fieldNIP: CustomTextField!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var fieldPosition: CustomTextField!
    @IBOutlet weak var fieldUnit: CustomTextField!
    @IBOutlet weak var labelUsername: CustomLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
