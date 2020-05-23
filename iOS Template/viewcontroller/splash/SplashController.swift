//
//  SplashController.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class SplashController: BaseViewController {
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        
        preference.saveBool(value: true, key: constant.IS_RELEASE)
                
        changeScreen()
    }
    
    private func setupView() {
        imageLogo.image = UIImage(named: "logo")?.tinted(with: UIColor.white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func changeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let isLogin = self.preference.getBool(key: self.constant.IS_LOGIN)
            
            if isLogin {
                self.navigationController?.pushViewController(HomeVC(), animated: true)
            } else {
                self.navigationController?.pushViewController(LoginVC(), animated: true)
            }
        }
    }
    
}
