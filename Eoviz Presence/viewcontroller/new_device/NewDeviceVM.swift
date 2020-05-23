//
//  NewDeviceVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 26/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class NewDeviceVM: BaseViewModel, DialogAlertProtocol {
    
    var isLoading = BehaviorRelay(value: false)
    
    func nextAction2(nc: UINavigationController?) { }
    
    func nextAction(nc: UINavigationController?) {
        nc?.popViewController(animated: true)
    }
    
    func newDevice(nc: UINavigationController?, username: String, password: String) {
        isLoading.accept(true)
        
        let body: [String: String] = [
            "username": username,
            "password": password,
            "device_id": "\(UIDevice().identifierForVendor?.description ?? "")",
            "device_brand": "iPhone",
            "device_series": UIDevice().name
        ]
        
        networking.newDevice(body: body) { (error, success, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.showDelegateDialogAlert(image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
