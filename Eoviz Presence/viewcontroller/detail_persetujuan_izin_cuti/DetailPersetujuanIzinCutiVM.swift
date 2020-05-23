//
//  DetailPersetujuanIzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class DetailPersetujuanIzinCutiVM: BaseViewModel {
    var listCutiTahunan = BehaviorRelay(value: [CutiTahunanItem]())
    var dontReload = BehaviorRelay(value: false)
    var isLoading = BehaviorRelay(value: false)
    var detailIzinCuti = BehaviorRelay(value: DetailIzinCutiData())
    var listInformasiStatus = BehaviorRelay(value: [DetailIzinCutiInformationStatusItem]())
    
    func resetVariabel() {
        dontReload.accept(false)
    }
    
    func submitLeaveApproval(isApproved: Bool, statusNote: String, permissionId: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        var body: [String: Any] = [
            "permission_id": permissionId,
            "action": isApproved ? "3" : "2",
            "status_note": statusNote
        ]
        
        if listCutiTahunan.value.count > 0 {
            var arrayDates = [String]()
            var arrayActionDates = [String]()
            
            listCutiTahunan.value.forEach { item in
                arrayDates.append(PublicFunction.dateStringTo(date: item.date, fromPattern: "dd MMMM yyyy", toPattern: "yyyy-MM-dd"))
                arrayActionDates.append(item.isApprove ? "3" : "2")
            }
            
            body.updateValue(arrayDates, forKey: "dates")
            body.updateValue(arrayActionDates, forKey: "action_date")
        } else {
            let arrayDateRange = (detailIzinCuti.value.date_range ?? " - ").components(separatedBy: " - ")
            body.updateValue(PublicFunction.dateStringTo(date: arrayDateRange[0], fromPattern: "dd MMMM yyyy", toPattern: "yyyy-MM-dd"), forKey: "date_start")
            body.updateValue(PublicFunction.dateStringTo(date: arrayDateRange[1], fromPattern: "dd MMMM yyyy", toPattern: "yyyy-MM-dd"), forKey: "date_end")
        }
        
        print(body)
        
        networking.submitLeaveApproval(body: body) { (error, success, isExpired) in
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
                self.detailCuti(nc: nc, permissionId: permissionId)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
    
    func detailCuti(nc: UINavigationController?, permissionId: String) {
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
                
                var array = [CutiTahunanItem]()
                
                for (index, item) in _data.dates.enumerated() {
                    array.append(CutiTahunanItem(date: item.date ?? "", isApprove: item.status ?? 0 != 1, isFirst: index == 0, isLast: index == _data.dates.count - 1, isOnlyOne: _data.dates.count == 1))
                }
                
                self.listCutiTahunan.accept(array)
            } else {
                self.showAlertDialog(image: nil, message: _detailIzinCuti.messages[0], navigationController: nc)
            }
        }
    }
    
    func changeAllApproval(isOn: Bool) {
        var array = listCutiTahunan.value
        
        for (index, item) in array.enumerated() {
            var newItem = item
            newItem.isApprove = isOn
            
            array[index] = newItem
        }
        
        listCutiTahunan.accept(array)
    }
    
    func changeApproval(index: Int) {
        var array = self.listCutiTahunan.value
        var newItem = array[index]
        newItem.isApprove = !newItem.isApprove
        array[index] = newItem
        self.listCutiTahunan.accept(array)
        dontReload.accept(false)
    }
}
