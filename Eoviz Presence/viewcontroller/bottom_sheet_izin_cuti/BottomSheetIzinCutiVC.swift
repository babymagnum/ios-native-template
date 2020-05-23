//
//  BottomSheetIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 28/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import MobileCoreServices
import Toast_Swift

protocol BottomSheetIzinCutiProtocol {
    func fileOrImagePicked(image: UIImage?, data: Data, fileName: String)
}

class BottomSheetIzinCutiVC: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewAmbilFoto: UIView!
    @IBOutlet weak var viewPilihAlbumFoto: UIView!
    @IBOutlet weak var viewUnggahDokumen: UIView!
    
    var delegate: BottomSheetIzinCutiProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvent()
    }
    
    private func setupEvent() {
        viewAmbilFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAmbilFotoClick)))
        viewPilihAlbumFoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPilihAlbumFotoClick)))
        viewUnggahDokumen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUnggahDokumenClick)))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension BottomSheetIzinCutiVC: UIDocumentPickerDelegate {
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
    
    @objc func viewPilihAlbumFotoClick() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false

        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func viewUnggahDokumenClick() {
        let allowedFiles = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
        let importMenu = UIDocumentPickerViewController(documentTypes: allowedFiles, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    // Image picker callback
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSObject!){
        guard let _image = image else {
            self.showAlertDialog(image: nil, description: "image_cant_be_picked".localize())
            return
        }
        
        guard let imageData = _image.jpegData(compressionQuality: 0.1) else { return }
        
        dismiss(animated: true, completion: nil)
        
        delegate?.fileOrImagePicked(image: _image, data: imageData, fileName: "\(PublicFunction.getCurrentMillis()).png")
    }
    
    // Camera callback
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            self.showAlertDialog(image: nil, description: "please_take_another_photo".localize())
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        dismiss(animated: true, completion: nil)
        
        delegate?.fileOrImagePicked(image: image, data: imageData, fileName: "\(PublicFunction.getCurrentMillis()).png")
    }
    
    // Document picker callback
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else { return }
        
        let data = try? Data(contentsOf: myURL)
        guard let _data = data else { return }
        let filename = "\(myURL)".components(separatedBy: "/").last ?? "\(PublicFunction.getCurrentMillis()).png"
        let fileType = "\(filename)".components(separatedBy: ".")[1]
        
        if fileType.lowercased().contains(regex: "(jpg|png|jpeg)") {
            let image = UIImage.init(data: _data)
            guard let _image = image, let _imageData = _image.jpegData(compressionQuality: 0.1) else { return }
            
            delegate?.fileOrImagePicked(image: _image, data: _imageData, fileName: filename)
        } else {
            delegate?.fileOrImagePicked(image: nil, data: _data, fileName: filename)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
