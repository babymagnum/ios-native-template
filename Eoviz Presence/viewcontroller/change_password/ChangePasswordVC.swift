//
//  ChangePasswordVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import SVProgressHUD
import RxSwift

class ChangePasswordVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fieldSandiLama: CustomTextField!
    @IBOutlet weak var fieldSandiBaru: CustomTextField!
    @IBOutlet weak var fieldUlangiSandiBaru: CustomTextField!
    @IBOutlet weak var viewSubmit: CustomGradientView!
    @IBOutlet weak var viewParent: CustomView!
    
    @Inject private var changePasswordVM: ChangePasswordVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        changePasswordVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewSubmit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewSubmitClick)))
    }

    private func setupView() {
        fieldSandiLama.delegate = self
        fieldSandiBaru.delegate = self
        fieldUlangiSandiBaru.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension ChangePasswordVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldSandiLama {
            fieldSandiLama.resignFirstResponder()
            fieldSandiBaru.becomeFirstResponder()
        } else if textField == fieldSandiBaru {
            fieldSandiBaru.resignFirstResponder()
            fieldUlangiSandiBaru.becomeFirstResponder()
        } else {
            fieldUlangiSandiBaru.resignFirstResponder()
        }
        return true
    }
    
    @objc func viewSubmitClick() {
        if fieldSandiLama.trim() == "" {
            showAlertDialog(image: nil, description: "old_password_is_empty".localize())
        } else if fieldSandiBaru.trim() == "" {
            showAlertDialog(image: nil, description: "new_password_is_empty".localize())
        } else if fieldUlangiSandiBaru.trim() == "" {
            showAlertDialog(image: nil, description: "confirm_new_password_is_empty".localize())
        } else if fieldUlangiSandiBaru.trim() != fieldSandiBaru.trim() {
            showAlertDialog(image: nil, description: "password_not_match".localize())
        } else {
            changePasswordVM.changePassword(old: fieldSandiLama.trim(), new: fieldSandiBaru.trim(), confirm: fieldUlangiSandiBaru.trim(), nc: navigationController)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
