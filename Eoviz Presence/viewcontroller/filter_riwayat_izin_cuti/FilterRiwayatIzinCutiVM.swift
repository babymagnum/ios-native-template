//
//  FilterRiwayatIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterRiwayatIzinCutiVM: BaseViewModel {
    var statusId = BehaviorRelay(value: "")
    var status = BehaviorRelay(value: "all".localize())
    var tahun = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "yyyy"))
    var typePicker = BehaviorRelay(value: "")
    var listStatus = BehaviorRelay(value: ["all".localize(), "saved".localize(), "submitted".localize(), "rejected".localize(), "approved".localize(), "canceled".localize()])
    var listStatusId = BehaviorRelay(value: ["", "0", "1", "2", "3", "4"])
    var listYears : BehaviorRelay<[String]> {
        var years = [String]()
        let currentYears = Int(PublicFunction.getStringDate(pattern: "yyyy")) ?? 2020
        for i in (2000..<currentYears + 2).reversed() {
            years.append("\(i)")
        }
        return BehaviorRelay(value: years)
    }
    
    func setTahun(index: Int) { tahun.accept(listYears.value[index]) }
    
    func setTypePicker(typePicker: String) { self.typePicker.accept(typePicker) }
    
    func setStatus(index: Int) {
        status.accept(listStatus.value[index])
        statusId.accept(listStatusId.value[index])
    }
    
    func resetFilterRiwayatIzinCuti() {
        tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
        status.accept("all".localize())
        statusId.accept("")
    }
}
