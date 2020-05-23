//
//  HomeVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/05/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

class HomeVM: BaseViewModel {
    
    var notificationLimit = 0
    
    func getNotification(completion: @escaping(_ hasNotification: Bool) -> Void) {
        networking.notificationList(page: 0) { (error, notification, isExpired) in
            if let _error = error {
                if _error == self.constant.CONNECTION_ERROR {
                    if self.notificationLimit <= 3 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.notificationLimit += 1
                            self.getNotification { _ in }
                        }
                    }
                }
                return
            }
            
            guard let _notification = notification else { return }
            
            if _notification.status {
                completion((_notification.data?.is_unread ?? 0) > 0)
            }
        }
    }
}
