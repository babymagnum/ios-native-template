//
//  FilterRiwayatTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterRiwayatTukarShiftVM: BaseViewModel {
    var statusId = BehaviorRelay(value: "")
    var status = BehaviorRelay(value: "all".localize())
    var tahun = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "yyyy"))
    var typePicker = BehaviorRelay(value: "")
    
    func setTahun(tahun: String) { self.tahun.accept(tahun) }
    
    func setTypePicker(typePicker: String) { self.typePicker.accept(typePicker) }
    
    func setStatus(status: String, statusId: String) {
        self.status.accept(status)
        self.statusId.accept(statusId)
    }
    
    func resetFilterRiwayatTukarShift() {
        tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
        status.accept("all".localize())
        statusId.accept("")
    }
}
