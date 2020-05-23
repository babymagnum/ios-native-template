//
//  LoginVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD

class LoginVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fieldEmail: CustomTextField!
    @IBOutlet weak var fieldPassword: CustomTextField!
    @IBOutlet weak var viewLogin: CustomGradientView!
    
    @Inject var loginVM: LoginVM
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        setupEvent()
    }
    
    private func observeData() {
        loginVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        #if DEBUG
        fieldEmail.text = "bambang@mailinator.com"
        fieldPassword.text = "123456"
        #endif
        
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
        viewLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewLoginClick)))
    }
    
    @objc func viewLoginClick() {
        
    }
    
    @IBAction func buttonForgotPasswordClick(_ sender: Any) {
        
    }
    
    @IBAction func buttonNewDeviceClick(_ sender: Any) {
        
    }
}
