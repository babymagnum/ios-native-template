//
//  DetailPersetujuanTukarShift.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import SVProgressHUD

class DetailPersetujuanTukarShiftVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var labelSwitch: CustomLabel!
    @IBOutlet weak var viewProses: CustomGradientView!
    @IBOutlet weak var labelNomer: CustomLabel!
    @IBOutlet weak var labelDiajukanPada: CustomLabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var imagePengaju: CustomImage!
    @IBOutlet weak var labelNamaPengaju: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengaju: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengaju: CustomLabel!
    @IBOutlet weak var labelAlasanPengaju: CustomLabel!
    @IBOutlet weak var imagePengganti: CustomImage!
    @IBOutlet weak var labelNamaPengganti: CustomLabel!
    @IBOutlet weak var labelUnitKerjaPengganti: CustomLabel!
    @IBOutlet weak var labelTanggalShiftPengganti: CustomLabel!
    @IBOutlet weak var collectionInformationStatus: UICollectionView!
    @IBOutlet weak var collectionInformationStatusHeight: NSLayoutConstraint!
    @IBOutlet weak var textviewCatatan: CustomTextView!
    @IBOutlet weak var viewStatus: CustomGradientView!
    
    private var disposeBag = DisposeBag()
    @Inject private var detailIzinCutiVM: DetailIzinCutiVM
    @Inject private var detailPersetujuanTukarShiftVM: DetailPersetujuanTukarShiftVM
    @Inject private var detailPengajuanTukarShiftVM: DetailPengajuanTukarShiftVM
    
    var shiftExchangeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupEvent()
        
        observeData()
        
        detailPersetujuanTukarShiftVM.detailExchangeShiftApproval(shiftExchangeId: shiftExchangeId ?? "", nc: navigationController)
    }
    
    private func setupView() {
        collectionInformationStatus.register(UINib(nibName: "InformasiStatusCell", bundle: .main), forCellWithReuseIdentifier: "InformasiStatusCell")
        collectionInformationStatus.delegate = self
        collectionInformationStatus.dataSource = self
    }
    
    private func observeData() {
        detailPersetujuanTukarShiftVM.isApprove.subscribe(onNext: { value in
            self.labelSwitch.text = value ? "approve".localize() : "reject".localize()
        }).disposed(by: disposeBag)
        
        detailPersetujuanTukarShiftVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        detailPersetujuanTukarShiftVM.detailExchangeShift.subscribe(onNext: { value in
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
            
            self.viewStatus.startColor = self.detailPengajuanTukarShiftVM.startColor(status: value.exchange_status ?? 0)
            self.viewStatus.endColor = self.detailPengajuanTukarShiftVM.endColor(status: value.exchange_status ?? 0)
            
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
        switchStatus.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        viewProses.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewProsesClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension DetailPersetujuanTukarShiftVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailPersetujuanTukarShiftVM.detailExchangeShift.value.information_status.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InformasiStatusCell", for: indexPath) as! InformasiStatusCell
        let data = detailPersetujuanTukarShiftVM.detailExchangeShift.value.information_status[indexPath.item]
        cell.labelName.text = data.emp_name
        cell.labelType.text = data.exchange_status
        cell.labelDateTime.text = data.status_datetime
        cell.labelStatus.text = detailIzinCutiVM.getStatusString(status: data.status ?? 0)
        cell.imageStatus.image = detailIzinCutiVM.getStatusImage(status: data.status ?? 0)
        cell.viewDot.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.backgroundColor = indexPath.item == 0 ? UIColor.windowsBlue : UIColor.slateGrey
        cell.viewLine.isHidden = indexPath.item == detailPersetujuanTukarShiftVM.detailExchangeShift.value.information_status.count - 1
        cell.viewLineTop.isHidden = indexPath.item == 0
        cell.viewLineTop.backgroundColor = indexPath.item <= 1 ? UIColor.windowsBlue : UIColor.slateGrey
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusWidth = (screenWidth - 60 - 30) * 0.2
        let textMargin = screenWidth - 119 - statusWidth
        let item = detailPersetujuanTukarShiftVM.detailExchangeShift.value.information_status[indexPath.item]
        let nameHeight = item.emp_name?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let typeHeight = item.exchange_status?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let dateTimeHeight = item.status_datetime?.getHeight(withConstrainedWidth: textMargin, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize())) ?? 0
        return CGSize(width: screenWidth - 60 - 30, height: nameHeight + typeHeight + dateTimeHeight + 10)
    }
}

extension DetailPersetujuanTukarShiftVC: DialogPermintaanTukarShiftProtocol {
    func actionClick() {
        dismiss(animated: true, completion: nil)
        
        detailPersetujuanTukarShiftVM.submitExchangeShiftApproval(shiftExchangeId: shiftExchangeId ?? "", note: textviewCatatan.text.trim(), nc: navigationController)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewProsesClick() {
        if textviewCatatan.text.trim() == "" {
            self.view.makeToast("status_note_cant_be_empty".localize())
        } else {
            let vc = DialogPermintaanTukarShift()
            vc.delegate = self
            vc.content = detailPersetujuanTukarShiftVM.isApprove.value ? "approve_change_shift".localize() : "reject_change_shift".localize()
            vc.isApprove = detailPersetujuanTukarShiftVM.isApprove.value
            showCustomDialog(vc)
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        detailPersetujuanTukarShiftVM.isApprove.accept(mySwitch.isOn)
    }
}
