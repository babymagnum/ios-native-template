//
//  ForgotPasswordEmailVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 26/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class ForgotPasswordEmailVM: BaseViewModel, DialogAlertProtocol {
    
    var isLoading = BehaviorRelay(value: false)
    
    func nextAction2(nc: UINavigationController?) { }
    
    func nextAction(nc: UINavigationController?) {
        guard let forgotPasswordEmailVC = nc?.viewControllers.last(where: { $0.isKind(of: ForgotPasswordEmailVC.self) }) else { return }
        let removedIndex = nc?.viewControllers.lastIndex(of: forgotPasswordEmailVC) ?? 0
        
        nc?.pushViewController(ForgotPasswordPinVC(), animated: true)
        
        nc?.viewControllers.remove(at: removedIndex)
    }
    
    func forgetPassword(email: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.forgetPassword(email: email) { (error, success, _) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.preference.saveString(value: email, key: self.constant.EMAIL)
                self.showDelegateDialogAlert(image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
}
