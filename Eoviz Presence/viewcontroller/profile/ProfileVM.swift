//
//  ProfileVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 12/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class ProfileVM: BaseViewModel {
    var imageData = BehaviorRelay(value: Data())
    var image = BehaviorRelay(value: UIImage())
    var profileData = BehaviorRelay(value: ProfileData())
    var isLoading = BehaviorRelay(value: false)
    var showToast = BehaviorRelay(value: false)
    var successUpdateProfile = BehaviorRelay(value: false)
    var prepareUpload = BehaviorRelay(value: PrepareUploadData())
    
    @Inject private var filterJamKerjaTimVM: FilterJamKerjaTimVM
    
    func updateImage(_imageData: Data, _image: UIImage) {
        imageData.accept(_imageData)
        image.accept(_image)
    }
    
    func prepareUploadLeave(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.prepareUpload(type: "updateProfile") { (error, prepareUpload, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _prepareUpload = prepareUpload, let _data = _prepareUpload.data else { return }
            
            self.prepareUpload.accept(_data)
        }
    }
    
    func logout(navigationController: UINavigationController?) {
        isLoading.accept(true)
        
        networking.logout { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.filterJamKerjaTimVM.listKaryawan.accept([FilterKaryawanDataItem]())
                self.resetData(navigationController: navigationController)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: navigationController)
            }
        }
    }
    
    func getProfileData(navigationController: UINavigationController?) {
        isLoading.accept(true)
        
        networking.profile { (error, profile, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: navigationController)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                self.showToast.accept(true)
                return
            }
            
            guard let _profile = profile, let _profileData = _profile.data else { return }
            
            if _profile.status {
                self.profileData.accept(_profileData)
            } else {
                self.showAlertDialog(image: nil, message: _profile.messages[0], navigationController: navigationController)
                self.showToast.accept(true)
            }
        }
    }
    
    func updateProfile(navigationController: UINavigationController?) {
        isLoading.accept(true)
        
        networking.updateProfile(data: imageData.value) { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: navigationController)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.successUpdateProfile.accept(true)
            } else {
                let vc = DialogAlertArrayVC()
                vc.listException = _success.messages
                self.showCustomDialog(destinationVC: vc, navigationController: navigationController)
            }
        }
    }
    
}
