//
//  RiwayatTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class RiwayatTukarShiftVM: BaseViewModel {
    var listRiwayatTukarShift = BehaviorRelay(value: [RiwayatTukarShiftItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmpty = BehaviorRelay(value: false)
    var emptyMessage = BehaviorRelay(value: "")
    
    var currentRiwayatPage = 0
    var totalRiwayatPage = 1
    @Inject private var filterRiwayatTukarShiftVM: FilterRiwayatTukarShiftVM
    
    func getRiwayatTukarShift(isFirst: Bool, nc: UINavigationController?) {
        
        if isFirst {
            currentRiwayatPage = 0
            totalRiwayatPage = 1
            listRiwayatTukarShift.accept([RiwayatTukarShiftItem]())
        }
        
        if currentRiwayatPage < totalRiwayatPage {
            isLoading.accept(true)
            
            networking.getExchangeShiftHistory(page: "\(currentRiwayatPage)", year: self.filterRiwayatTukarShiftVM.tahun.value, status: self.filterRiwayatTukarShiftVM.statusId.value) { (error, riwayatTukarShift, isExpired) in
                
                self.isLoading.accept(false)
                
                if let _ = isExpired {
                    self.forceLogout(navigationController: nc)
                    return
                }
                
                if let _error = error {
                    self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                    return
                }
                
                guard let _riwayatTukarShift = riwayatTukarShift, let data = _riwayatTukarShift.data else { return }
                
                self.emptyMessage.accept(_riwayatTukarShift.messages[0])
                
                if _riwayatTukarShift.status {
                    var array = self.listRiwayatTukarShift.value
                    
                    data.list.forEach { item in
                        array.append(item)
                    }
                    
                    self.listRiwayatTukarShift.accept(array)
                    self.showEmpty.accept(self.listRiwayatTukarShift.value.count == 0)
                    
                    self.currentRiwayatPage += 1
                    self.totalRiwayatPage = data.total_page
                } else {
                    self.showAlertDialog(image: nil, message: _riwayatTukarShift.messages[0], navigationController: nc)
                }
            }
        }
    }
}
