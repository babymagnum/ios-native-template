//
//  JamKerjaTimVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class JamKerjaTimVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var url = BehaviorRelay(value: "")
    
    func daftarShift(nc: UINavigationController?, data: (dateStart: String, dateEnd: String, listKaryawan: [String])) {
        isLoading.accept(true)
        
        networking.daftarShift(data: data) { (error, daftarShift, isExpired) in
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _daftarShift = daftarShift, let _data = _daftarShift.data else { return }
            
            if _daftarShift.status {
                self.url.accept(_data.url ?? "")
            } else {
                self.showAlertDialog(image: nil, message: _daftarShift.messages[0], navigationController: nc)
            }
        }
    }
}
