//
//  FilterRiwayatIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit
import FittedSheets

protocol FilterRiwayatIzinCutiProtocol {
    func applyFilter()
}

class FilterRiwayatIzinCutiVC: BaseViewController {

    @IBOutlet weak var viewReset: CustomGradientView!
    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var labelStatus: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var viewStatus: CustomView!
    
    var delegate: FilterRiwayatIzinCutiProtocol?
    
    @Inject private var filterRiwayatIzinCutiVM: FilterRiwayatIzinCutiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeData()
        
        setupEvent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupEvent() {
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewStatus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewStatusClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
        viewReset.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewResetClick)))
    }
    
    private func observeData() {
        filterRiwayatIzinCutiVM.tahun.subscribe(onNext: { value in
            self.labelTahun.text = value
        }).disposed(by: disposeBag)
        
        filterRiwayatIzinCutiVM.status.subscribe(onNext: { value in
            self.labelStatus.text = value
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
}

extension FilterRiwayatIzinCutiVC: BottomSheetPickerProtocol {
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getItem(index: Int) {
        if filterRiwayatIzinCutiVM.typePicker.value == "status" {
            filterRiwayatIzinCutiVM.setStatus(index: index)
        } else {
            filterRiwayatIzinCutiVM.setTahun(index: index)
        }
    }
    
    @objc func viewTerapkanClick() {
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewResetClick() {
        filterRiwayatIzinCutiVM.resetFilterRiwayatIzinCuti()
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewStatusClick() {
        filterRiwayatIzinCutiVM.setTypePicker(typePicker: "status")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = filterRiwayatIzinCutiVM.listStatus.value
        vc.selectedValue = filterRiwayatIzinCutiVM.status.value
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @objc func viewTahunClick() {
        filterRiwayatIzinCutiVM.setTypePicker(typePicker: "tahun")
        let vc = BottomSheetPickerVC()
        vc.delegate = self
        vc.singleArray = filterRiwayatIzinCutiVM.listYears.value
        vc.selectedValue = filterRiwayatIzinCutiVM.tahun.value
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.4)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
}
