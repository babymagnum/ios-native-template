//
//  ProfileVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift
import SVProgressHUD
import Toast_Swift

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var fieldNIP: CustomTextField!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var fieldPosition: CustomTextField!
    @IBOutlet weak var fieldUnit: CustomTextField!
    @IBOutlet weak var labelUsername: CustomLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @Inject var profileVM: ProfileVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
        
        profileVM.prepareUploadLeave(nc: navigationController)
    }
    
    private func observeData() {
        profileVM.imageData.subscribe(onNext: { value in
            if value != Data() {
                self.profileVM.updateProfile(navigationController: self.navigationController)
            }
        }).disposed(by: disposeBag)
        
        profileVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        profileVM.profileData.subscribe(onNext: { value in
            self.fieldNIP.text = value.emp_number ?? "" == "" ? "-" : value.emp_number
            self.fieldPosition.text = value.emp_position ?? "" == "" ? "-" : value.emp_position
            self.fieldUnit.text = value.emp_unit ?? "" == "" ? "-" : value.emp_unit
            self.labelUsername.text = value.emp_name
            self.imageUser.loadUrl(value.photo ?? "")
        }).disposed(by: disposeBag)
        
        profileVM.showToast.subscribe(onNext: { value in
            if value {
                self.view.makeToast("swipe_to_refresh".localize())
            }
        }).disposed(by: disposeBag)
        
        profileVM.successUpdateProfile.subscribe(onNext: { value in
            if value {
                self.imageUser.image = self.profileVM.image.value
                self.showAlertDialog(image: "24BasicCircleGreen", description: "success_update_profile".localize())
            }
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        scrollView.addSubview(refreshControl)
        viewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewImageClick)))
    }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        profileVM.getProfileData(navigationController: navigationController)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension ProfileVC {
    @IBAction func buttonKeluarClick(_ sender: Any) {
        PublicFunction.showUnderstandDialog(self, "Eoviz Presence", "are_you_sure_want_to_logout".localize(), "logout".localize(), "cancel_batal".localize()) {
            self.profileVM.logout(navigationController: self.navigationController)
        }
    }
    
    @IBAction func buttonSettingClick(_ sender: Any) {
        //let settingsVC = UINavigationController.init(rootViewController: SettingsVC())
        //settingsVC.isNavigationBarHidden = true
        //self.present(settingsVC, animated: true, completion: nil)
        navigationController?.pushViewController(SettingsVC(), animated: true)
    }
    
    @objc func viewImageClick() {
        let sheetController = SheetViewController(controller: BottomSheetProfilVC(), sizes: [.fixed(screenWidth * 0.55)])
        sheetController.handleColor = UIColor.clear
        sheetController.topCornersRadius = 50
        self.present(sheetController, animated: false, completion: nil)
    }
}
