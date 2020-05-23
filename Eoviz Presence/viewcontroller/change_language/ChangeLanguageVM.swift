//
//  ChangeLanguageVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 23/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ChangeLanguageVM: BaseViewModel {
    
    var isLoading = BehaviorRelay(value: false)
    
    func changeLanguage(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.changeLanguage { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.setupRootController(vc: SplashController(), animationOptions: nil)
                self.preference.saveBool(value: false, key: self.constant.IS_SETUP_LANGUAGE)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
