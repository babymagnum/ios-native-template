//
//  RiwayatIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class RiwayatIzinCutiVM: BaseViewModel {
    var listRiwayatIzinCuti = BehaviorRelay(value: [RiwayatIzinCutiItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmpty = BehaviorRelay(value: false)
    var emptyMessage = BehaviorRelay(value: "")
    
    @Inject private var filterRiwayatIzinCutiVM: FilterRiwayatIzinCutiVM
    private var totalRiwayatPage = 1
    private var currentRiwayatPage = 0
    
    func getRiwayatIzinCuti(isFirst: Bool, nc: UINavigationController?) {
        
        if isFirst {
            totalRiwayatPage = 1
            currentRiwayatPage = 0
            listRiwayatIzinCuti.accept([RiwayatIzinCutiItem]())
        }
        
        if currentRiwayatPage < totalRiwayatPage {
            isLoading.accept(true)
            
            networking.historyCuti(page: currentRiwayatPage, year: filterRiwayatIzinCutiVM.tahun.value, perstypeId: "", permissionStatus: filterRiwayatIzinCutiVM.statusId.value) { (error, riwayatIzinCuti, isExpired) in
                self.isLoading.accept(false)
                
                if let _ = isExpired {
                    self.forceLogout(navigationController: nc)
                    return
                }
                
                if let _error = error {
                    self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                    return
                }
                
                guard let _riwayatIzinCuti = riwayatIzinCuti, let _data = _riwayatIzinCuti.data else { return }
                
                if _riwayatIzinCuti.status {
                    var array = self.listRiwayatIzinCuti.value
                    
                    _data.list.forEach { item in
                        array.append(item)
                    }
                    
                    self.listRiwayatIzinCuti.accept(array)
                    self.showEmpty.accept(self.listRiwayatIzinCuti.value.count == 0)
                    
                    if self.listRiwayatIzinCuti.value.count == 0 {
                        self.emptyMessage.accept(_riwayatIzinCuti.messages[0])
                    }
                    
                    self.currentRiwayatPage += 1
                    self.totalRiwayatPage = _data.total_page
                } else {
                    self.showAlertDialog(image: nil, message: _riwayatIzinCuti.messages[0], navigationController: nc)
                }
            }
        }
    }
}
