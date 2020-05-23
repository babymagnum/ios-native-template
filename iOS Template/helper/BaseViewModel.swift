//
//  BaseViewModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import EzPopup

class BaseViewModel {
    
    lazy var networking: Networking = {
        return Networking()
    }()
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
    
    lazy var screenWidth : CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    lazy var screenHeight : CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    func resetData(navigationController: UINavigationController?) {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        preference.saveBool(value: false, key: constant.IS_SETUP_LANGUAGE)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.setupRootController(vc: SplashController(), animationOptions: nil)
    }
    
    func showCustomDialog(destinationVC: UIViewController, navigationController: UINavigationController?) {
        let popupVc = PopupViewController(contentController: destinationVC, popupWidth: screenWidth, popupHeight: screenHeight)
        popupVc.shadowEnabled = false
        navigationController?.present(popupVc, animated: true)
    }
    
    func showAlertDialog(image: String?, message: String, navigationController: UINavigationController?) {
        let vc = DialogAlert()
        vc.stringDescription = message
        vc.image = image
        
        let popupVc = PopupViewController(contentController: vc, popupWidth: screenWidth, popupHeight: screenHeight)
        popupVc.shadowEnabled = false
        navigationController?.present(popupVc, animated: true)
    }
    
    func forceLogout(navigationController: UINavigationController?) {
        let vc = DialogAlert()
        vc.stringDescription = "please_login_again".localize()
        showCustomDialog(destinationVC: vc, navigationController: navigationController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData(navigationController: navigationController)
        })
    }
    
    func showDelegateDialogAlert(image: String?, delegate: DialogAlertProtocol?, content: String?, nc: UINavigationController?) {
        let vc = DialogAlert()
        vc.delegate = delegate
        vc.stringDescription = content
        vc.nc = nc
        vc.image = image
        showCustomDialog(destinationVC: vc, navigationController: nc)
    }
    
    func showDelegateDialogAlertWithAction2(image: String?, action2String: String?, delegate: DialogAlertProtocol?, content: String?, nc: UINavigationController?) {
        let vc = DialogAlert()
        vc.delegate = delegate
        vc.stringDescription = content
        vc.nc = nc
        vc.image = image
        vc.action2String = action2String
        showCustomDialog(destinationVC: vc, navigationController: nc)
    }
}
