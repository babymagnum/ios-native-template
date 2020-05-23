//
//  NotificationVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class NotificationVM: BaseViewModel {
    var listNotifikasi = BehaviorRelay(value: [NotificationItem]())
    var isLoading = BehaviorRelay(value: false)
    var showEmpty = BehaviorRelay(value: false)
    var emptyNotification = BehaviorRelay(value: "")
    var hasUnreadNotification = BehaviorRelay(value: false)
    var updateNotification = BehaviorRelay(value: false)
    
    private var totalNotifikasiPage = 1
    private var currentNotifikasiPage = 0
    
    func updateNotificationRead(index: Int, notificationId: String, nc: UINavigationController?) {
        networking.updateNotificationRead(notificationId: notificationId) { (error, success, isExpired) in
            if let _ = isExpired {
                self.forceLogout(navigationController: nc)
                return
            }
            
            if let _ = error {
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                self.updateRead(index: index)
            }
        }
    }
    
    private func updateRead(index: Int) {
        var array = listNotifikasi.value
        array[index].notification_is_read = 1
        listNotifikasi.accept(array)
    }
    
    func getNotifikasi(isFirst: Bool, nc: UINavigationController?) {
        
        if isFirst {
            totalNotifikasiPage = 1
            currentNotifikasiPage = 0
            listNotifikasi.accept([NotificationItem]())
        }
        
        if currentNotifikasiPage < totalNotifikasiPage {
            isLoading.accept(true)
            
            networking.notificationList(page: currentNotifikasiPage) { (error, notification, isExpired) in
                self.isLoading.accept(false)
                
                if let _ = isExpired {
                    self.forceLogout(navigationController: nc)
                    return
                }
                
                if let _error = error {
                    self.emptyNotification.accept(_error)
                    self.showAlertDialog(image: nil, message: _error, navigationController: nc)
                    return
                }
                
                guard let _notification = notification, let _data = _notification.data else { return }
                
                self.emptyNotification.accept(_notification.messages[0])
                
                if _notification.status {
                    self.updateNotification.accept(false)
                    self.hasUnreadNotification.accept(_data.is_unread > 0)
                    
                    var array = self.listNotifikasi.value
                    
                    _data.notification.forEach { item in
                        array.append(item)
                    }
                    
                    self.listNotifikasi.accept(array)
                    self.showEmpty.accept(self.listNotifikasi.value.count == 0)
                    
                    self.currentNotifikasiPage += 1
                    self.totalNotifikasiPage = _data.total_page
                } else {
                    self.showAlertDialog(image: nil, message: _notification.messages[0], navigationController: nc)
                }
            }
        }
    }
}
