//
//  FilterDaftarPresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class FilterDaftarPresensiVM {
    var fullDate = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "dd-MMMM-yyyy"))
    var bulan = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "MM"))
    var tahun = BehaviorRelay(value: PublicFunction.getStringDate(pattern: "yyyy"))
    
    func updateBulanTahun(fullDate: String) {
        let date = PublicFunction.dateStringTo(date: fullDate, fromPattern: "dd-MM-yyyy", toPattern: "dd-MMMM-yyyy")
        self.fullDate.accept(date)
        let arrayDate = fullDate.components(separatedBy: "-")
        self.bulan.accept(arrayDate[1])
        self.tahun.accept(arrayDate[2])
    }
    
    func resetFilterDaftarPresensi() {
        self.fullDate.accept(PublicFunction.getStringDate(pattern: "dd-MMMM-yyyy"))
        self.bulan.accept(PublicFunction.getStringDate(pattern: "MM"))
        self.tahun.accept(PublicFunction.getStringDate(pattern: "yyyy"))
    }
}
