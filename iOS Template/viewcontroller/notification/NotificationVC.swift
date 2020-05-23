//
//  NotificationVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift

class NotificationVC: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var collectionNotifikasi: UICollectionView!
    @IBOutlet weak var viewEmptyNotifikasi: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
