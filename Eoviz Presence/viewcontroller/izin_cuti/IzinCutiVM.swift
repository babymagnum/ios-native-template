//
//  IzinCutiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

enum ViewPickType {
    case rentangTanggalAwal
    case rentangTanggalAkhir
    case tanggalMeninggalkanPekerjaan
    case waktuMulai
    case waktuSelesai
    case tanggalCuti
}

class IzinCutiVM: BaseViewModel, DialogAlertProtocol {
    
    var listTipeCuti = BehaviorRelay(value: [TipeCutiItem]())
    var listJatahCuti = BehaviorRelay(value: [JatahCutiItem]())
    var listTanggalCuti = BehaviorRelay(value: [TanggalCutiItem]())
    var isLoading = BehaviorRelay(value: false)
    var selectedJenisCuti = BehaviorRelay(value: 0)
    var isDateExist = BehaviorRelay(value: false)
    var viewPickType = BehaviorRelay(value: ViewPickType.rentangTanggalAkhir)
    var cuti = BehaviorRelay(value: GetCutiData())
    var prepareUpload = BehaviorRelay(value: PrepareUploadData())
    
    func addTanggalCuti(date: String) {
        var array = listTanggalCuti.value
        
        if array.contains(where: {($0.date == date)}) {
            isDateExist.accept(true)
        } else {
            array.append(TanggalCutiItem(date: date, isLast: true, isFirst: true, isOnlyOne: true))
            
            for (index, item) in array.enumerated() {
                array[index] = TanggalCutiItem(date: item.date, isLast: index == array.count - 1, isFirst: index == 0, isOnlyOne: array.count == 1)
            }
            
            listTanggalCuti.accept(array)
        }
    }
    
    func deleteTanggalCuti(position: Int) {
        var array = listTanggalCuti.value
        array.remove(at: position)
        
        for (index, item) in array.enumerated() {
            array[index] = TanggalCutiItem(date: item.date, isLast: index == array.count - 1, isFirst: index == 0, isOnlyOne: array.count == 1)
        }
        
        listTanggalCuti.accept(array)
    }
    
    func nextAction2(nc: UINavigationController?) { }
    
    func nextAction(nc: UINavigationController?) {
        guard let izinCutiVC = nc?.viewControllers.last(where: { $0.isKind(of: IzinCutiVC.self) }) else { return }
        let removedIndex = nc?.viewControllers.lastIndex(of: izinCutiVC) ?? 0
        
        nc?.pushViewController(RiwayatIzinCutiVC(), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            nc?.viewControllers.remove(at: removedIndex)
        }
    }
    
    // MARK: Networking
    func submitCuti(oldFileName: String?, data: Data?, fileName: String?, fileType: String?, isRange: Bool, date: String?, dateStart: String, dateEnd: String, sendType: String, permissionId: String, permissionTypeId: Int, reason: String, nc: UINavigationController?, completion: @escaping() -> Void) {
        
        var body: [String: Any] = [
            "perstype_id": "\(permissionTypeId)",
            "reason": reason,
            "send_type": sendType,
            "permission_id": permissionId
        ]
        
        if isRange {
            body.updateValue(PublicFunction.dateStringTo(date: dateStart, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), forKey: "date_start")
            body.updateValue(PublicFunction.dateStringTo(date: dateEnd, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), forKey: "date_end")
        } else {
            var array = [String]()
            
            if let _date = date {
                array.append(PublicFunction.dateStringTo(date: _date, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))
            } else {
                listTanggalCuti.value.forEach { item in
                    array.append(PublicFunction.dateStringTo(date: item.date, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))
                }
            }
            
            body.updateValue(array, forKey: "dates")
        }
        
        isLoading.accept(true)
        
        networking.submitCuti(body: body, oldFileName: oldFileName, data: data, fileName: fileName, fileType: fileType) { (error, success, isExpired) in
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
                completion()
                self.showDelegateDialogAlert(image: "24BasicCircleGreen", delegate: self, content: _success.messages[0], nc: nc)
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: nc)
            }
        }
    }
    
    func getCutiTahunan(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.jatahCuti { (error, jatahCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _jatahCuti = jatahCuti, let _data = _jatahCuti.data else { return }
            
            if _jatahCuti.status {
                self.listJatahCuti.accept(_data.list)
            } else {
                self.showAlertDialog(image: nil, message: _jatahCuti.messages[0], navigationController: nc)
            }
        }
    }
    
    func tipeCuti(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.tipeCuti { (error, tipeCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _tipeCuti = tipeCuti, let _data = _tipeCuti.data else { return }
            
            if _tipeCuti.status {
                var array = [TipeCutiItem]()
                
                //array.append(TipeCutiItem(perstype_id: 0, perstype_name: "pick_leave_type".localize(), is_range: 0, is_quota_reduce: 0, is_allow_backdate: 0, max_date: 0))
                
                _data.list.forEach { item in
                    array.append(item)
                }
                
                self.listTipeCuti.accept(array)
            } else {
                self.showAlertDialog(image: nil, message: _tipeCuti.messages[0], navigationController: nc)
            }
        }
    }
    
    func getCuti(permissiondId: String, nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.getCuti(permissiondId: permissiondId) { (error, getCuti, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _getCuti = getCuti, let _data = _getCuti.data else { return }
            
            if _getCuti.status {
                var array = [TanggalCutiItem]()
                
                // here we repeat the loop to get desired form in collectionview
                _data.dates.forEach { item in
                    array.append(TanggalCutiItem(date: PublicFunction.dateStringTo(date: item, fromPattern: "yyyy-MM-dd", toPattern: "dd/MM/yyyy"), isLast: true, isFirst: true, isOnlyOne: true))
                }
                
                for (index, item) in array.enumerated() {
                    array[index] = TanggalCutiItem(date: item.date, isLast: index == array.count - 1, isFirst: index == 0, isOnlyOne: array.count == 1)
                }
                
                let index = self.listTipeCuti.value.firstIndex{$0.perstype_id == _data.perstype_id}
                                
                self.selectedJenisCuti.accept(index ?? 0)
                self.listTanggalCuti.accept(array)
                self.cuti.accept(_data)
            } else {
                self.showAlertDialog(image: nil, message: _getCuti.messages[0], navigationController: nc)
            }
        }
    }
    
    func prepareUploadLeave(nc: UINavigationController?) {
        isLoading.accept(true)
        
        networking.prepareUpload(type: "submitLeave") { (error, prepareUpload, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                return
            }
            
            guard let _prepareUpload = prepareUpload, let _data = _prepareUpload.data else { return }
            
            self.prepareUpload.accept(_data)
        }
    }
}

//    func submitCuti(isRange: Bool, date: String?, dateStart: String, dateEnd: String, sendType: String, permissionId: String, permissionTypeId: String, reason: String, nc: UINavigationController?) {
//        isLoading.accept(true)
//
//        guard let url = URL(string: "\(BaseNetworking().baseUrl())/v1/submitLeave") else { return }
//
//        var bodyRequest = "perstype_id=\(permissionTypeId)&reason=\(reason)&send_type=\(sendType)&permission_id=\(permissionId)"
//
//        if isRange {
//            bodyRequest += "&date_start=\(PublicFunction.dateStringTo(date: dateStart, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))"
//            bodyRequest += "&date_end=\(PublicFunction.dateStringTo(date: dateEnd, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))"
//        } else {
//            if let _date = date {
//                bodyRequest += "&dates[]=\(PublicFunction.dateStringTo(date: _date, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))"
//            } else {
//                listTanggalCuti.value.forEach { item in
//                    bodyRequest += "&dates[]=\(PublicFunction.dateStringTo(date: item.date, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"))"
//                }
//            }
//        }
//
//        let data : Data = bodyRequest.data(using: .utf8)!
//        var request : URLRequest = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
//        request.setValue("Bearer \(preference.getString(key: constant.TOKEN))", forHTTPHeaderField:"Authorization");
//        request.httpBody = data
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//
//            DispatchQueue.main.async {
//                self.isLoading.accept(false)
//
//                guard let status = response as? HTTPURLResponse else { return }
//
//                if status.statusCode == 401 {
//                    self.forceLogout(navigationController: nc)
//                } else if let error = error {
//                    self.showAlertDialog(image: nil, message: error.localizedDescription, navigationController: nc)
//                } else if let data = data {
//                    do {
//                        let success = try JSONDecoder().decode(Success.self, from: data)
//
//                        print(success)
//
//                        if success.status {
//                            self.showDelegateDialogAlert(image: "24BasicCircleGreen", delegate: self, content: success.messages[0], nc: nc)
//                        } else {
//                            self.showAlertDialog(image: nil, message: success.messages[0], navigationController: nc)
//                        }
//                    } catch let err {
//                        self.showAlertDialog(image: nil, message: err.localizedDescription, navigationController: nc)
//                    }
//                }
//            }
//        })
//        task.resume()
//    }
