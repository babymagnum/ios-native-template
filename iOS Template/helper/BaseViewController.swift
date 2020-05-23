//
//  BaseViewController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit
import EzPopup

class BaseViewController: UIViewController {
    
    lazy var preference: Preference = {
        return Preference()
    }()
    
    lazy var constant: Constant = {
        return Constant()
    }()
    
    lazy var function: PublicFunction = {
        return PublicFunction()
    }()
    
    lazy var networking: Networking = {
        return Networking()
    }()
    
    lazy var screenWidth : CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    lazy var screenHeight : CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.windowsBlue
        
        return refreshControl
    }()
    
    private var popRecognizer: InteractivePopRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        enableSwipePopBack(navigationController: navigationController)
    }
    
    func enableSwipePopBack(navigationController: UINavigationController?) {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    func addBlurView(view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 1
        view.addSubview(blurEffectView)
    }
    
    func removeBlurView(view: UIView) {
        let viewTag = view.viewWithTag(1)
        viewTag?.removeFromSuperview()
    }
    
    func showAlertDialog(image: String?, description: String?) {
        let vc = DialogAlert()
        vc.stringDescription = description
        vc.image = image
        showCustomDialog(vc)
    }
    
    func showCustomDialog(_ vc: UIViewController) {
        let popupVc = PopupViewController(contentController: vc, popupWidth: screenWidth, popupHeight: screenHeight)
        popupVc.shadowEnabled = false
        self.present(popupVc, animated: true)
    }
    
    func forceLogout(_navigationController: UINavigationController?) {
        let vc = DialogAlert()
        vc.stringDescription = "please_login_again".localize()
        self.showCustomDialog(vc)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.resetData(_navigationController: _navigationController)
        })
    }
    
    func resetData(_navigationController: UINavigationController?) {
        preference.saveBool(value: false, key: constant.IS_LOGIN)
        preference.saveBool(value: false, key: constant.IS_SETUP_LANGUAGE)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.setupRootController(vc: SplashController(), animationOptions: nil)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        _handleRefresh(refreshControl: refreshControl)
    }
    
    func _handleRefresh(refreshControl: UIRefreshControl) {}
}
