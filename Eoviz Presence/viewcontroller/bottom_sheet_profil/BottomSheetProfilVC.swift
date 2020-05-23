//
//  BottomSheetProfilVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

class BottomSheetProfilVC: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewAmbilFoto: UIView!
    @IBOutlet weak var viewPilihFoto: UIView!
    
    @Inject var profileVM: ProfileVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }

    private func setupEvent() {
        viewAmbilFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAmbilFotoClick)))
        viewPilihFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPilihFotoClick)))
    }
}

extension BottomSheetProfilVC {
    
    @objc func viewAmbilFotoClick() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            showAlertDialog(image: nil, description: "device_has_no_camera".localize())
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func viewPilihFotoClick() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false

        present(imagePicker, animated: true, completion: nil)
    }
    
    // Image picker callback
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSObject!){
        guard let _image = image else {
            self.showAlertDialog(image: nil, description: "image_cant_be_picked".localize())
            return
        }
        
        guard let imageData = _image.jpegData(compressionQuality: 0.1) else { return }
        
        if profileVM.prepareUpload.value.file_extension.contains("png") && imageData.count <= profileVM.prepareUpload.value.file_max_size ?? 0 {
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.profileVM.updateImage(_imageData: imageData, _image: _image)
            }
        } else {
            self.view.makeToast("file_not_supported".localize())
        }
    }
    
    // Camera callback
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            self.showAlertDialog(image: nil, description: "please_take_another_photo".localize())
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        if profileVM.prepareUpload.value.file_extension.contains("png") && imageData.count <= profileVM.prepareUpload.value.file_max_size ?? 0 {
            dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.profileVM.updateImage(_imageData: imageData, _image: image)
            }
        } else {
            self.view.makeToast("file_not_supported".localize())
        }
    }
}
