//
//  DetailIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class DetailIzinCutiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewItemLampiran: CustomView!
    @IBOutlet weak var labelLampiran: CustomLabel!
    @IBOutlet weak var viewLampiran: UIView!
    @IBOutlet weak var viewLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var viewStatus: CustomGradientView!
    @IBOutlet weak var imagePengaju: CustomImage!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelJenis: CustomLabel!
    @IBOutlet weak var labelAlasan: CustomLabel!
    @IBOutlet weak var labelTanggalCuti: CustomLabel!
    @IBOutlet weak var collectionInformasiStatus: UICollectionView!
    @IBOutlet weak var collectionInformasiStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCatatan: CustomLabel!
    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewActionParent: UIView!
    @IBOutlet weak var viewActionParentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var viewInformasiStatus: CustomView!
    
    @Inject private var detailPengajuanTukarShiftVM: DetailPengajuanTukarShiftVM
    @Inject private var detailIzinCutiVM: DetailIzinCutiVM
    private var disposeBag = DisposeBag()
    
    var permissionId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        detailIzinCutiVM.getDetailCuti(nc: navigationController, permissionId: permissionId ?? "")
    }
    
    private func observeData() {
        detailIzinCutiVM.listInformasiStatus.subscribe(onNext: { value in
            self.collectionInformasiStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
                    self.viewInformasiStatus.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
        
        detailIzinCutiVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        detailIzinCutiVM.detailIzinCuti.subscribe(onNext: { value in
            var stringDate = ""
            
            if value.dates.count > 0 {
                for (index, item) in value.dates.enumerated() {
                    if index == value.dates.count - 1 {
                        stringDate += "\(item.date ?? "")"
                    } else {
                        stringDate += "\(item.date ?? ""), "
                    }
                }
            } else {
                stringDate = value.date_range ?? ""
            }
            
            self.labelNomer.text = value.permission_number
            self.labelDiajukanPada.text = "\("submitted_on".localize()) \(value.permission_date_request ?? "")"
            self.viewStatus.startColor = self.detailPengajuanTukarShiftVM.startColor(status: value.permission_status ?? 0)
            self.viewStatus.endColor = self.detailPengajuanTukarShiftVM.endColor(status: value.permission_status ?? 0)
            self.imageStatus.image = self.detailPengajuanTukarShiftVM.statusImage(status: value.permission_status ?? 0)
            self.labelStatus.text = self.detailPengajuanTukarShiftVM.statusString(status: value.permission_status ?? 0)
            self.imagePengaju.loadUrl(value.employee?.photo ?? "")
            self.labelName.text = value.employee?.name
            self.labelUnitKerja.text = value.employee?.unit ?? "" == "" ? "-" : value.employee?.unit
            self.labelJenis.text = value.perstype_name
            self.labelAlasan.text = value.permission_reason
            self.labelTanggalCuti.text = stringDate
            self.labelCatatan.text = value.cancel_note
            
            self.viewActionParent.isHidden = !(value.cancel_button ?? false)
            self.viewActionParentHeight.constant = value.cancel_button ?? false ? 1000 : 0
            
            self.viewCatatanHeight.constant = value.cancel_button ?? false ? 0 : 1000
            self.viewCatatan.isHidden = value.cancel_button ?? false
            
            let hasAttachment = (value.attachment?.url ?? "") != ""
            
            self.viewLampiran.isHidden = !hasAttachment
            self.viewLampiranHeight.constant = hasAttachment ? 1000 : 0
            self.labelLampiran.text = value.attachment?.name
            
            self.collectionInformasiStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        collectionInformasiStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformasiStatus.delegate = self
        collectionInformasiStatus.dataSource = self
    }
    
    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
        viewItemLampiran.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewItemLampiranClick)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension DetailIzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailIzinCutiVM.listInformasiStatus.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
        let data = detailIzinCutiVM.listInformasiStatus.value[indexPath.item]
        cell.labelName.text = data.emp_name
        cell.labelType.text = data.permission_note
        cell.labelDateTime.text = data.status_datetime
        cell.labelStatus.text = detailIzinCutiVM.getStatusString(status: data.status ?? 0)
        cell.imageStatus.image = detailIzinCutiVM.getStatusImage(status: data.status ?? 0)
        
        cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.isHidden = indexPath.item == detailIzinCutiVM.listInformasiStatus.value.count - 1
        cell.viewLineTop.isHidden = indexPath.item == 0
        cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusWidth = (screenWidth - 60 - 30) * 0.2
        let textMargin = screenWidth - 119 - statusWidth
        let item = detailIzinCutiVM.listInformasiStatus.value[indexPath.item]
        let nameHeight = item.emp_name?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let typeHeight = item.permission_note?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let dateTimeHeight = item.status_datetime?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize())) ?? 0
        return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
    }
}

extension DetailIzinCutiVC: DialogBatalkanCutiProtocol, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    func actionClick(cancelNotes: String) {
        detailIzinCutiVM.cancelCuti(nc: navigationController, permissionId: permissionId ?? "", cancelNote: cancelNotes)
    }
    
    // Document opener callback
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        SVProgressHUD.dismiss()
        
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                let docOpener = UIDocumentInteractionController.init(url: destinationURL)
                docOpener.delegate = self
                docOpener.presentPreview(animated: true)
            }
        } catch let error {
            self.showAlertDialog(image: nil, description: error.localizedDescription)
        }
    }
    
    @objc func viewItemLampiranClick() {
        guard let url = URL(string: detailIzinCutiVM.detailIzinCuti.value.attachment?.url ?? "") else {
            self.showAlertDialog(image: nil, description: "invalid_link".localize())
            return
        }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "please_wait".localize())
    }
    
    @objc func viewActionClick() {
        let vc = DialogBatalkanIzinCutiVC()
        vc.delegate = self
        showCustomDialog(vc)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
