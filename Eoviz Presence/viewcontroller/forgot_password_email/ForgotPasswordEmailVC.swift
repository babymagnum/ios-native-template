//
//  ForgotPasswordEmailVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import DIKit

class ForgotPasswordEmailVC: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var viewSend: CustomGradientView!
    
    @Inject private var forgotPasswordEmailVM: ForgotPasswordEmailVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        fieldEmail.text = "bambang@mailinator.com"
        #endif
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        forgotPasswordEmailVM.isLoading.subscribe(onNext: { value in
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
        fieldEmail.delegate = self
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

extension ForgotPasswordEmailVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail {
            fieldEmail.resignFirstResponder()
        }
        return true
    }
    
    @objc func viewSendClick() {
        if fieldEmail.trim() == "" {
            self.view.makeToast("email_cant_empty".localize())
        } else {
            forgotPasswordEmailVM.forgetPassword(email: fieldEmail.trim(), nc: navigationController)
        }
    }

    @objc func imageBackClick() {
        navigationController?.popToViewController(ofClass: LoginVC.self)
    }
}
