//
//  FilterDaftarPresensiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import FittedSheets
import DIKit
import RxSwift

protocol FilterDaftarPresensiProtocol {
    func applyFilter()
}

class FilterDaftarPresensiVC: BaseViewController {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewBulan: CustomView!
    @IBOutlet weak var viewTahun: CustomView!
    @IBOutlet weak var labelBulan: CustomLabel!
    @IBOutlet weak var labelTahun: CustomLabel!
    @IBOutlet weak var viewTerapkan: CustomGradientView!
    @IBOutlet weak var viewReset: CustomGradientView!
    
    var delegate: FilterDaftarPresensiProtocol?
    
    private var disposeBag = DisposeBag()
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        observeData()
    }
    
    private func observeData() {
        filterDaftarPresensiVM.fullDate.subscribe(onNext: { value in
            let dateArray = value.components(separatedBy: "-")
            self.labelBulan.text = dateArray[1]
            self.labelTahun.text = dateArray[2]
        }).disposed(by: disposeBag)
    }
    
    private func setupEvent() {
        viewBulan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBulanClick)))
        viewTahun.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTahunClick)))
        viewTerapkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTerapkanClick)))
        viewReset.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewResetClick)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension FilterDaftarPresensiVC: BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String) {
        filterDaftarPresensiVM.updateBulanTahun(fullDate: formatedDate)
    }
    
    func pickTime(pickedTime: String) { }
    
    private func openDatePicker() {
        let vc = BottomSheetDatePickerVC()
        vc.delegate = self
        vc.picker = .date
        vc.isBackDate = true
        vc.currentDate = PublicFunction.stringToDate(date: filterDaftarPresensiVM.fullDate.value, pattern: "dd-MM-yyyy")
        let sheetController = SheetViewController(controller: vc, sizes: [.fixed(screenHeight * 0.5)])
        sheetController.handleColor = UIColor.clear
        present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewTerapkanClick() {
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewResetClick() {
        filterDaftarPresensiVM.resetFilterDaftarPresensi()
        navigationController?.popViewController(animated: true)
        delegate?.applyFilter()
    }
    
    @objc func viewTahunClick() {
        openDatePicker()
    }
    
    @objc func viewBulanClick() {
        openDatePicker()
    }
}
