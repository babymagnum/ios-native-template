//
//  SettingsVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController {

    @IBOutlet weak var viewUbahKataSandi: UIView!
    @IBOutlet weak var viewBahasa: CustomView!
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var labelValueLanguage: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupEvent() {
        viewUbahKataSandi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUbahKataSandiClick)))
        viewBahasa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBahasaClick)))
    }
    
    private func setupView() {
        let language = preference.getString(key: constant.LANGUAGE)
        labelValueLanguage.text = language == constant.INDONESIA ? "Bahasa Indonesia" : "English"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension SettingsVC {
    @IBAction func backButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewUbahKataSandiClick() {
        navigationController?.pushViewController(ChangePasswordVC(), animated: true)
    }
    
    @objc func viewBahasaClick() {
        navigationController?.pushViewController(ChangeLanguageVC(), animated: true)
    }
}
