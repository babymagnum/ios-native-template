//
//  NewDeviceVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD
import Toast_Swift

class NewDeviceVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewRequest: CustomGradientView!
    
    @Inject private var newDeviceVM: NewDeviceVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        fieldEmail.text = "bambang@mailinator.com"
        fieldPassword.text = "123456"
        #endif
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        newDeviceVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "pleae_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
        viewRequest.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewRequestClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension NewDeviceVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
            fieldPassword.becomeFirstResponder()
        } else {
            fieldPassword.resignFirstResponder()
        }
        return true
    }
    
    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewRequestClick() {
        if fieldEmail.trim() == "" {
            self.view.makeToast("email_cant_empty".localize())
        } else if fieldPassword.trim() == "" {
            self.view.makeToast("password_cant_empty".localize())
        } else {
            newDeviceVM.newDevice(nc: navigationController, username: fieldEmail.trim(), password: fieldPassword.trim())
        }
    }
}
