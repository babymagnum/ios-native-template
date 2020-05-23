//
//  DaftarPresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DaftarPresensiVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var listPresensi = BehaviorRelay(value: [DaftarPresensiItem]())
    var showEmpty = BehaviorRelay(value: false)
    var labelEmpty = BehaviorRelay(value: "")
    
    func getListPresensi(date: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.presenceList(date: date) { (error, daftarPresensi, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _daftarPresensi = daftarPresensi else { return }
            
            if _daftarPresensi.status {
                self.labelEmpty.accept(_daftarPresensi.messages[0])
                self.showEmpty.accept(_daftarPresensi.data?.list.count == 0)
                self.listPresensi.accept(_daftarPresensi.data?.list ?? [DaftarPresensiItem]())
            } else {
                self.showAlertDialog(image: nil, message: _daftarPresensi.messages[0], navigationController: nc)
            }
        }
    }
}
