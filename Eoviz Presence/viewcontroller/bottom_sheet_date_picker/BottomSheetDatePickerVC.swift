//
//  BottomSheetDatePickerVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

protocol BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String)
    func pickTime(pickedTime: String)
}

enum PickerTypeEnum {
    case date
    case time
}

class BottomSheetDatePickerVC: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    
    var delegate: BottomSheetDatePickerProtocol?
    var picker: PickerTypeEnum!
    var isBackDate: Bool!
    var startDate: String?
    var maxDate: Int?
    var currentDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        let language = preference.getString(key: constant.LANGUAGE)
        datePicker.locale = Locale(identifier: language)
        
        switch picker {
        case .date?: datePicker.datePickerMode = .date
            default: datePicker.datePickerMode = .time
        }
        
        if !isBackDate {
            datePicker.minimumDate = PublicFunction.stringToDate(date: PublicFunction.getStringDate(pattern: "yyyy-MM-dd"), pattern: "yyyy-MM-dd")
        }
        
        if let _startDate = startDate, let _maxDate = maxDate {
            let nextDate = Calendar.current.date(byAdding: .day, value: _maxDate - 1, to: PublicFunction.stringToDate(date: _startDate, pattern: "dd/MM/yyyy"))
            datePicker.maximumDate = nextDate
        }
        
        if let _currentDate = currentDate {
            datePicker.date = _currentDate
        }
    }
}

extension BottomSheetDatePickerVC {
    @IBAction func buttonPilihClick(_ sender: Any) {
        switch picker {
            case .date?: delegate?.pickDate(formatedDate: PublicFunction.dateToString(datePicker.date, "dd-MM-yyyy"))
        case .time?: delegate?.pickTime(pickedTime: PublicFunction.dateToString(datePicker.date, "HH:mm"))
            default: break
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChange(_ sender: Any) {
        switch picker {
        case .date?:
            print("")
        case .time?:
            print("")
        default: break
        }
    }
}
