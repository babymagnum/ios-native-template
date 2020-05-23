//
//  LoginVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import DIKit
import RxRelay

class LoginVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    
    func login(username: String, password: String, navigationController: UINavigationController?) {
        isLoading.accept(true)
        
        networking.login(username: username, password: password) { (error, login, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                return
            }
            
            if let _login = login {
                if _login.status {
                    if let _data = _login.data {
                        self.preference.saveString(value: "\(_data.emp_id)", key: self.constant.USER_ID)
                        self.preference.saveString(value: _data.token, key: self.constant.TOKEN)
                        self.preference.saveString(value: _data.emp_lang, key: self.constant.LANGUAGE)
                        self.preference.saveBool(value: true, key: self.constant.IS_LOGIN)
                        
                        if !self.preference.getBool(key: self.constant.IS_SETUP_LANGUAGE) {
                            
                            self.preference.saveBool(value: true, key: self.constant.IS_SETUP_LANGUAGE)
                            
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                            
                            appDelegate.setupRootController(vc: HomeVC(), animationOptions: nil)
                        }
                    }
                } else {
                    self.showAlertDialog(image: nil, message: _login.messages[0], navigationController: navigationController)
                }
            }
        }
    }
    
}
