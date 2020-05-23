//
//  PresenceMapVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 23/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay
import DIKit

class PresenceMapVM: BaseViewModel {
    
    var isLoading = BehaviorRelay(value: false)
    @Inject private var berandaVM: BerandaVM
    
    func presence(presenceId: String, presenceType: String, latitude: Double, longitude: Double, navigationController: UINavigationController?) {
        
        isLoading.accept(true)
        
        let body: [String: String] = [
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "preszone_id": presenceId,
            "presence_type": presenceType
        ]
        
        print("body presence \(body)")
        
        networking.presence(body: body) { (error, success, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: navigationController)
                return
            }
            
            if let _error = error {
                self.showAlertDialog(image: nil, message: _error, navigationController: navigationController)
                return
            }
            
            guard let _success = success else { return }
            
            if _success.status {
                guard let presenceMapVC = navigationController?.viewControllers.last(where: { $0.isKind(of: PresenceMapVC.self) }) else { return }
                let index = navigationController?.viewControllers.lastIndex(of: presenceMapVC) ?? 0
                
                navigationController?.pushViewController(DaftarPresensiVC(), animated: true)

                navigationController?.viewControllers.remove(at: index)
                
                self.berandaVM.getBerandaData()
            } else {
                self.showAlertDialog(image: nil, message: _success.messages[0], navigationController: navigationController)
            }
        }
    }
}
