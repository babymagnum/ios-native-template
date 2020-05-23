//
//  DetailPengajuanTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class DetailPengajuanTukarShiftVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewCatatan: UIView!
    @IBOutlet weak var viewCatatanHeight: NSLayoutConstraint!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var labelNamaPengaju: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengaju: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengaju: CustomLabel!
    @IBOutlet weak var labelAlasanPengaju: CustomLabel!
    @IBOutlet weak var imagePengaju: CustomImage!
    @IBOutlet weak var imagePengganti: CustomImage!
    @IBOutlet weak var labelNamaPengganti: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengganti: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengganti: CustomLabel!
    @IBOutlet weak var viewAction: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewActionHeight: CustomMargin!
    @IBOutlet weak var viewActionMarginTop: NSLayoutConstraint!
    @IBOutlet weak var collectionInformationStatus: UICollectionView!
    @IBOutlet weak var collectionInformationStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelCatatan: CustomLabel!
    @IBOutlet weak var viewStatus: CustomGradientView!
    
    @Inject private var detailIzinCutiVM: DetailIzinCutiVM
    @Inject private var detailPengajuanTukarShiftVM: DetailPengajuanTukarShiftVM
    private var disposeBag = DisposeBag()
    
    var shiftExchangeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        detailPengajuanTukarShiftVM.detailExchangeShift(shiftExchangeId: shiftExchangeId ?? "", nc: navigationController)
    }
    
    private func observeData() {
        detailPengajuanTukarShiftVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        detailPengajuanTukarShiftVM.detailExchangeShift.subscribe(onNext: { value in
            self.labelNomer.text = value.exchange_number
            self.labelDiajukanPada.text = "\("submitted_on".localize()) \(value.request_date ?? "")"
            self.labelStatus.text = self.detailPengajuanTukarShiftVM.statusString(status: value.exchange_status ?? 0)
            self.imageStatus.image = self.detailPengajuanTukarShiftVM.statusImage(status: value.exchange_status ?? 0)
            self.imagePengaju.loadUrl(value.requestor?.photo ?? "")
            self.labelNamaPengaju.text = value.requestor?.emp_name
            self.labelUnitKerjaPengaju.text = value.requestor?.emp_unit ?? "" == "" ? "-" : value.requestor?.emp_unit
            self.labelTanggalShiftPengaju.text = value.requestor?.shift_date
            self.labelAlasanPengaju.text = value.requestor?.reason
            self.imagePengganti.loadUrl(value.subtituted?.photo ?? "")
            self.labelNamaPengganti.text = value.subtituted?.emp_name
            self.labelUnitKerjaPengganti.text = value.subtituted?.emp_unit ?? "" == "" ? "-" : value.subtituted?.emp_unit
            self.labelTanggalShiftPengganti.text = value.subtituted?.shift_date
            self.labelCatatan.text = value.cancel_note
            
            self.viewStatus.startColor = self.detailPengajuanTukarShiftVM.startColor(status: value.exchange_status ?? 0)
            self.viewStatus.endColor = self.detailPengajuanTukarShiftVM.endColor(status: value.exchange_status ?? 0)
            
            self.viewCatatan.isHidden = value.cancel_button ?? false
            self.viewCatatanHeight.constant = value.cancel_button ?? false ? 0 : 1000
            
            self.viewAction.isHidden = !(value.cancel_button ?? false)
            self.viewActionHeight.multi = value.cancel_button ?? false ? 0.11 : 0
            self.viewActionMarginTop.constant = value.cancel_button ?? false ? 20 : 0
            
            self.collectionInformationStatus.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.2) {
                    self.collectionInformationStatusHeight.constant = self.collectionInformationStatus.contentSize.height
                    self.view.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
    }

    private func setupEvent() {
        viewAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewActionClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionInformationStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformationStatus.delegate = self
        collectionInformationStatus.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension DetailPengajuanTukarShiftVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailPengajuanTukarShiftVM.detailExchangeShift.value.information_status.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
        let data = detailPengajuanTukarShiftVM.detailExchangeShift.value.information_status[indexPath.item]
        cell.labelName.text = data.emp_name
        cell.labelType.text = data.exchange_status
        cell.labelDateTime.text = data.status_datetime
        cell.labelStatus.text = detailIzinCutiVM.getStatusString(status: data.status ?? 0)
        cell.imageStatus.image = detailIzinCutiVM.getStatusImage(status: data.status ?? 0)
        cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.isHidden = indexPath.item == detailPengajuanTukarShiftVM.detailExchangeShift.value.information_status.count - 1
        cell.viewLineTop.isHidden = indexPath.item == 0
        cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusWidth = (screenWidth - 60 - 30) * 0.2
        let textMargin = screenWidth - 119 - statusWidth
        let item = detailPengajuanTukarShiftVM.detailExchangeShift.value.information_status[indexPath.item]
        let nameHeight = item.emp_name?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let typeHeight = item.exchange_status?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let dateTimeHeight = item.status_datetime?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize())) ?? 0
        return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
    }
}

extension DetailPengajuanTukarShiftVC: DialogBatalkanTukarShiftProtocol {
    func cancelTukarShift(alasan: String) {
        detailPengajuanTukarShiftVM.cancelExchangeShift(shiftExchangeId: shiftExchangeId ?? "", reason: alasan, nc: navigationController)
    }
    
    @objc func viewActionClick() {
        let vc = DialogBatalkanTukarShiftVC()
        vc.delegate = self
        showCustomDialog(vc)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
