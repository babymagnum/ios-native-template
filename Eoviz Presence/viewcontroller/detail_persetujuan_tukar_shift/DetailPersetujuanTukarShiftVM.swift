//
//  DetailPersetujuanTukarShiftVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DetailPersetujuanTukarShiftVM: BaseViewModel {
    var isApprove = BehaviorRelay(value: true)
    var isLoading = BehaviorRelay(value: false)
    var detailExchangeShift = BehaviorRelay(value: DetailExchangeShiftApprovalData())
    
    func submitExchangeShiftApproval(shiftExchangeId: String, note: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        let body: [String: String] = [
            "action": isApprove.value ? "3" : "2",
            "status_note": note,
            "shift_exchange_id": shiftExchangeId
        ]
        
        networking.submitExchangeShiftApproval(body: body) { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.showAlertDialog(image: "24BasicCircleGreen", message: _success.messages[0], navigationController: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
    
    func detailExchangeShiftApproval(shiftExchangeId: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.detailExchangeShiftApproval(shiftExchangeId: shiftExchangeId) { (error, detailExchangeShift, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _detailExchangeShift = detailExchangeShift, let _data = _detailExchangeShift.data else { return }
            
            if _detailExchangeShift.status {
                self.detailExchangeShift.accept(_data)
            } else {
                self.showAlertDialog(image: nil, message: _detailExchangeShift.messages[0], navigationController: nc)
            }
        }
    }
}
