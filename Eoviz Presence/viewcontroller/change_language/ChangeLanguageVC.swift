//
//  ChangeLanguageVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import SVProgressHUD
import RxSwift

class ChangeLanguageVC: BaseViewController {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewBahasaIndonesia: CustomView!
    @IBOutlet weak var viewEnglish: CustomView!
    @IBOutlet weak var buttonIndonesia: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    
    @Inject private var changeLanguageVM: ChangeLanguageVM
    private var disposeBag = DisposeBag()
    private var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        changeLanguageVM.isLoading.subscribe(onNext: { value in
            if value {
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewBahasaIndonesia.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBahasaIndonesiaClick)))
        viewEnglish.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEnglishClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        language = preference.getString(key: constant.LANGUAGE)
        
        if language == constant.INDONESIA {
            buttonEnglish.isHidden = true
        } else {
            buttonIndonesia.isHidden = true
        }
    }
}

extension ChangeLanguageVC {
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewEnglishClick() {
        if language != constant.ENGLISH {
            PublicFunction.showUnderstandDialog(self, "change_language?".localize(), "Apakah anda yakin mau mengganti bahasa menjadi English?", "Ya", "Tidak") {
                self.preference.saveString(value: self.constant.ENGLISH, key: self.constant.LANGUAGE)
                self.changeLanguageVM.changeLanguage(nc: self.navigationController)
            }
        }
    }
    
    @objc func viewBahasaIndonesiaClick() {
        if language != constant.INDONESIA {
            PublicFunction.showUnderstandDialog(self, "change_language?".localize(), "Are you sure want to change the language to Bahasa Indonesia?", "Yes", "No") {
                self.preference.saveString(value: self.constant.INDONESIA, key: self.constant.LANGUAGE)
                self.changeLanguageVM.changeLanguage(nc: self.navigationController)
            }
        }
    }
}
