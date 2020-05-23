//
//  DetailIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class DetailIzinCutiVM: BaseViewModel {
    var isLoading = BehaviorRelay(value: false)
    var listInformasiStatus = BehaviorRelay(value: [DetailIzinCutiInformationStatusItem]())
    var detailIzinCuti = BehaviorRelay(value: DetailIzinCutiData())
    
    @Inject private var riwayatIzinCutiVM: RiwayatIzinCutiVM
    
    // MARK: For informasi status item cell
    func getStatusImage(status: Int) -> UIImage? {
        if status == 0 {
            return UIImage(named: "24BasicCircleChecked")
        } else if status == 1 {
            return UIImage(named: "alarm24Px")
        } else if status == 2 {
            return UIImage(named: "24BasicCircleX")
        } else {
            return UIImage(named: "24BasicCircleGreen")
        }
    }
    
    func getStatusString(status: Int) -> String {
        if status == 0 {
            return "submitted".localize()
        } else if status == 1 {
            return "waiting".localize()
        } else if status == 2 {
            return "rejected".localize()
        } else {
            return "approved".localize()
        }
    }
    
    func cancelCuti(nc: UINavigationController?, permissionId: String, cancelNote: String) {
        isLoading.accept(true)
        
        networking.cancelCuti(permissionId: permissionId, statusNotes: cancelNote) { (error, success, isExpired) in
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
                self.getDetailCuti(nc: nc, permissionId: permissionId)
                self.riwayatIzinCutiVM.getRiwayatIzinCuti(isFirst: true, nc: nil)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
    
    func getDetailCuti(nc: UINavigationController?, permissionId: String) {
        isLoading.accept(true)
        
        networking.detailCuti(permissionId: permissionId) { (error, detailIzinCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _detailIzinCuti = detailIzinCuti, let _data = _detailIzinCuti.data else { return }
            
            if _detailIzinCuti.status {
                self.detailIzinCuti.accept(_data)
                
                self.listInformasiStatus.accept(_data.information_status)
            } else {
                self.showAlertDialog(image: nil, message: _detailIzinCuti.messages[0], navigationController: nc)
            }
        }
    }
}
