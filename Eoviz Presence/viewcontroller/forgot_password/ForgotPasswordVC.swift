//
//  ForgotPasswordVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import SVProgressHUD
import RxSwift
import Toast_Swift

class ForgotPasswordVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldNewPassword: CustomTextField!
    @IBOutlet weak var fieldConfirmPassword: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    
    @Inject private var forgotPasswordVM: ForgotPasswordVM
    private var disposeBag = DisposeBag()
    
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        forgotPasswordVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        fieldNewPassword.delegate = self
        fieldConfirmPassword.delegate = self
        viewSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSendClick)))
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension ForgotPasswordVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldNewPassword {
            fieldNewPassword.resignFirstResponder()
            fieldConfirmPassword.becomeFirstResponder()
        } else {
            fieldConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    @objc func viewSendClick() {
        if fieldNewPassword.trim() == "" {
            self.view.makeToast("new_password_cant_empty".localize())
        } else if fieldConfirmPassword.trim() != fieldNewPassword.trim() {
            self.view.makeToast("confirm_password_not_match".localize())
        } else {
            forgotPasswordVM.submitNewPassword(password: fieldNewPassword.trim(), code: code ?? "", nc: navigationController)
        }
    }
    
    @objc func imageBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
