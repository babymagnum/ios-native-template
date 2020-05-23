//
//  ForgotPasswordPinVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD
import Toast_Swift

class ForgotPasswordPinVC: BaseViewController {

    @IBOutlet weak var fieldPin1: CustomTextField!
    @IBOutlet weak var fieldPin2: CustomTextField!
    @IBOutlet weak var fieldPin3: CustomTextField!
    @IBOutlet weak var fieldPin4: CustomTextField!
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var viewSubmit: CustomGradientView!
    @IBOutlet weak var labelTimer: CustomLabel!
    
    @Inject private var forgotPasswordPinVM: ForgotPasswordPinVM
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forgotPasswordPinVM.startTimer()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        forgotPasswordPinVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        forgotPasswordPinVM.time.subscribe(onNext: { value in
            self.labelTimer.text = value
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageBackClick)))
        viewSubmit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSubmitClick)))
        observeTextField(focusTextField: fieldPin1, nextTextField: fieldPin2, isLast: false)
        observeTextField(focusTextField: fieldPin2, nextTextField: fieldPin3, isLast: false)
        observeTextField(focusTextField: fieldPin3, nextTextField: fieldPin4, isLast: false)
        observeTextField(focusTextField: fieldPin4, nextTextField: fieldPin2, isLast: true)
    }
    
    private func observeTextField(focusTextField: CustomTextField, nextTextField: CustomTextField, isLast: Bool) {
        focusTextField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { _ in
            if focusTextField.trim().count > 1 { focusTextField.text = "\(Array(focusTextField.text!)[1])" }
            
            if focusTextField.trim().count == 1 {
                if isLast {
                    focusTextField.resignFirstResponder()
                } else {
                    focusTextField.resignFirstResponder()
                    nextTextField.becomeFirstResponder()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension ForgotPasswordPinVC {
    @objc func viewSubmitClick() {
        let code = "\(fieldPin1.trim())\(fieldPin2.trim())\(fieldPin3.trim())\(fieldPin4.trim())"
        
        if code.count < 4 {
            self.view.makeToast("please_fill_code_correctly".localize())
        } else {
            forgotPasswordPinVM.submitVerificationCode(code: code, nc: navigationController)
        }
    }
    
    @objc func imageBackClick() {
        navigationController?.popToViewController(ofClass: LoginVC.self)
    }
}
