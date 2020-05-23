//
//  DetailPersetujuanIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD

class DetailPersetujuanIzinCutiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var labelLampiran: CustomLabel!
    @IBOutlet weak var viewItemLampiran: CustomView!
    @IBOutlet weak var viewLampiranHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLampiran: UIView!
    @IBOutlet weak var viewStatus: CustomGradientView!
    @IBOutlet weak var viewApprovalHeight: NSLayoutConstraint!
    @IBOutlet weak var viewApproval: UIView!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelUnitKerja: CustomLabel!
    @IBOutlet weak var labelJenisCuti: CustomLabel!
    @IBOutlet weak var labelAlasan: CustomLabel!
    @IBOutlet weak var labelTanggalCuti: CustomLabel!
    @IBOutlet weak var collectionInformasiStatus: UICollectionView!
    @IBOutlet weak var switchApproval: UISwitch!
    @IBOutlet weak var labelApproval: CustomLabel!
    @IBOutlet weak var collectionCutiTahunan: UICollectionView!
    @IBOutlet weak var viewCatatanStatus: UIView!
    @IBOutlet weak var viewCatatanStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var textviewCatatanStatus: UITextView!
    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCatatan: CustomLabel!
    @IBOutlet weak var viewActionParent: UIView!
    @IBOutlet weak var viewActionParentHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var collectionCutiTahunanHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionCutiTahunanTopMargin: NSLayoutConstraint!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionInformasiStatusHeight: NSLayoutConstraint!
    
    @Inject private var detailPengajuanTukarShiftVM: DetailPengajuanTukarShiftVM
    @Inject private var detailIzinCutiVM: DetailIzinCutiVM
    @Inject private var detailPersetujuanIzinCutiVM: DetailPersetujuanIzinCutiVM
    private var disposeBag = DisposeBag()
    
    var leaveId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPersetujuanIzinCutiVM.resetVariabel()
        
        setupView()
        
        observeData()
        
        setupEvent()
        
        getData()
    }
    
    private func getData() {
        detailPersetujuanIzinCutiVM.detailCuti(nc: navigationController, permissionId: leaveId ?? "")
    }
    
    private func setupEvent() {
        viewItemLampiran.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewItemLampiranClick)))
        switchApproval.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
        
        collectionCutiTahunan.collectionViewLayout.invalidateLayout()
    }
    
    private func observeData() {
        detailPersetujuanIzinCutiVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        detailPersetujuanIzinCutiVM.listCutiTahunan.subscribe(onNext: { value in
            if !self.detailPersetujuanIzinCutiVM.dontReload.value {
                self.collectionCutiTahunan.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.collectionCutiTahunanHeight.constant = self.collectionCutiTahunan.contentSize.height
                }
            }
            
            if value.count > 0 {
                let hasNoApprove = self.detailPersetujuanIzinCutiVM.listCutiTahunan.value.contains { item -> Bool in
                    return !item.isApprove
                }
                
                self.switchApproval.setOn(!hasNoApprove, animated: true)
                self.labelApproval.text = !hasNoApprove ? "approve_all".localize() : "reject_all".localize()
            }
        }).disposed(by: disposeBag)
        
        detailPersetujuanIzinCutiVM.listInformasiStatus.subscribe(onNext: { value in
            self.collectionInformasiStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionInformasiStatusHeight.constant = self.collectionInformasiStatus.contentSize.height
            }
        }).disposed(by: disposeBag)
        
        detailPersetujuanIzinCutiVM.detailIzinCuti.subscribe(onNext: { value in
            self.switchApproval.setOn(true, animated: true)
            self.labelApproval.text = value.perstype_name ?? "" == "Cuti Tahunan" ? "approve_all".localize() : "approve".localize()
            
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
            self.imageUser.loadUrl(value.employee?.photo ?? "")
            self.labelName.text = value.employee?.name
            self.labelUnitKerja.text = value.employee?.unit ?? "" == "" ? "-" : value.employee?.unit
            self.labelJenisCuti.text = value.perstype_name
            self.labelAlasan.text = value.permission_reason
            self.labelTanggalCuti.text = stringDate
            self.labelCatatan.text = value.cancel_note
            
            let hasAttachment = (value.attachment?.url ?? "") != ""
            
            self.viewLampiran.isHidden = !hasAttachment
            self.viewLampiranHeight.constant = hasAttachment ? 1000 : 0
            self.labelLampiran.text = value.attachment?.name
            
            self.viewActionParent.isHidden = !(value.cancel_button ?? false)
            self.viewActionParentHeight.constant = value.cancel_button ?? false ? 1000 : 0
            
            self.viewCatatanHeight.constant = value.cancel_button ?? false ? 0 : 1000
            self.viewCatatan.isHidden = value.cancel_button ?? false
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private func setupView() {
        collectionCutiTahunan.register(UINib(nibName: "CutiTahunanCell", bundle: .main), forCellWithReuseIdentifier: "CutiTahunanCell")
        collectionCutiTahunan.delegate = self
        collectionCutiTahunan.dataSource = self
        
        collectionInformasiStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformasiStatus.delegate = self
        collectionInformasiStatus.dataSource = self
    }
    
}

extension DetailPersetujuanIzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionInformasiStatus {
            return detailPersetujuanIzinCutiVM.listInformasiStatus.value.count
        } else {
            return detailPersetujuanIzinCutiVM.listCutiTahunan.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionInformasiStatus {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
            let data = detailPersetujuanIzinCutiVM.listInformasiStatus.value[indexPath.item]

            cell.labelName.text = data.emp_name
            cell.labelType.text = data.permission_note
            cell.labelDateTime.text = data.status_datetime
            cell.labelStatus.text = detailIzinCutiVM.getStatusString(status: data.status ?? 0)
            cell.imageStatus.image = detailIzinCutiVM.getStatusImage(status: data.status ?? 0)
            
            cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
            cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
            cell.viewLine.isHidden = indexPath.item == detailPersetujuanIzinCutiVM.listInformasiStatus.value.count - 1
            cell.viewLineTop.isHidden = indexPath.item == 0
            cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CutiTahunanCell", for: indexPath) as! CutiTahunanCell
            cell.data = detailPersetujuanIzinCutiVM.listCutiTahunan.value[indexPath.item]
            cell.switchApproval.addTarget(self, action: #selector(switchCellChanged), for: UIControl.Event.valueChanged)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionInformasiStatus {
            let statusWidth = (screenWidth - 60 - 30) * 0.2
            let textMargin = screenWidth - 119 - statusWidth
            let item = detailPersetujuanIzinCutiVM.listInformasiStatus.value[indexPath.item]
            let nameHeight = item.emp_name?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let typeHeight = item.permission_note?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let dateTimeHeight = item.status_datetime?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize())) ?? 0
            return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
        } else {
            return CGSize(width: screenWidth - 60, height: screenWidth * 0.11)
        }
    }
}

extension DetailPersetujuanIzinCutiVC: DialogPermintaanTukarShiftProtocol, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    func actionClick() {
        dismiss(animated: true, completion: nil)
        
        detailPersetujuanIzinCutiVM.submitLeaveApproval(isApproved: switchApproval.isOn, statusNote: textviewCatatanStatus.text.trim(), permissionId: leaveId ?? "", nc: navigationController)
    }
    
    @objc func viewActionClick() {
        if textviewCatatanStatus.text.trim() == "" {
            self.view.makeToast("status_note_cant_be_empty".localize())
        } else {
            let vc = DialogPermintaanTukarShift()
            vc.delegate = self
            vc.content = switchApproval.isOn ? "accept_leave_permission".localize() : "refuse_leave_permission".localize()
            vc.isApprove = switchApproval.isOn
            showCustomDialog(vc)
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchCellChanged(mySwitch: UISwitch) {
        detailPersetujuanIzinCutiVM.dontReload.accept(true)
        
        //Get the point in cell
        let center: CGPoint = mySwitch.center
        let rootViewPoint: CGPoint = mySwitch.superview?.convert(center, to: collectionCutiTahunan) ?? CGPoint(x: 0, y: 0)
        // Now get the indexPath
        let indexPath = collectionCutiTahunan.indexPathForItem(at: rootViewPoint)
        
        guard let _indexpath = indexPath else { return }
        
        detailPersetujuanIzinCutiVM.changeApproval(index: _indexpath.item)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        detailPersetujuanIzinCutiVM.dontReload.accept(false)
        detailPersetujuanIzinCutiVM.changeAllApproval(isOn: mySwitch.isOn)
        
        if detailPersetujuanIzinCutiVM.detailIzinCuti.value.perstype_name ?? "" == "Cuti Tahunan" {
            switchApproval.setOn(mySwitch.isOn, animated: true)
            labelApproval.text = mySwitch.isOn ? "approve_all".localize() : "reject_all".localize()
        } else {
            switchApproval.setOn(mySwitch.isOn, animated: true)
            labelApproval.text = mySwitch.isOn ? "approve".localize() : "reject".localize()
        }
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
        guard let url = URL(string: detailPersetujuanIzinCutiVM.detailIzinCuti.value.attachment?.url ?? "") else {
            self.showAlertDialog(image: nil, description: "invalid_link".localize())
            return
        }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        SVProgressHUD.show(withStatus: "please_wait".localize())
    }
}
