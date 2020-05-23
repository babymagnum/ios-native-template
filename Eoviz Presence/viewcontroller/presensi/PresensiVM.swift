//
//  PresensiVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 14/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class PresensiVM: BaseViewModel, DialogAlertProtocol {
    
    private var seconds = 0
    private var minutes = 0
    private var hours = 0
    private var timer: Timer?
    private var preparePresenceLimit = 1
    
    var time = BehaviorRelay(value: "")
    var isLoading = BehaviorRelay(value: false)
    var presence = BehaviorRelay(value: PresensiData())
    var message = BehaviorRelay(value: "")
    
    func presenceTime(time: String, timeZone: String) {
        if let _timer = timer {
            _timer.invalidate()
        }
        
        let timeArray = time.components(separatedBy: ":")
        
        seconds = Int(timeArray[2])!
        minutes = Int(timeArray[1])!
        hours = Int(timeArray[0])!

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            if self.time.value.count >= 12 && self.time.value.substring(toIndex: 5) != PublicFunction.getStringDate(pattern: "HH:mm") {
                let _timeArray = PublicFunction.getStringDate(pattern: "HH:mm:ss")
                
                self.presenceTime(time: _timeArray, timeZone: timeZone)
            }
            
            self.seconds += 1
            
            let time = "\(String(self.hours).count == 1 ? "0\(self.hours)" : "\(self.hours == 24 ? "00" : String(self.hours))"):\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(self.minutes == 60 ? "00" : String(self.minutes))"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(self.seconds == 60 ? "00" : String(self.seconds))") \(timeZone)"
            
            self.time.accept(time)
            
            if self.seconds == 60 {
                self.minutes += 1
                self.seconds = 0
            }
            
            if self.minutes == 60 {
                self.hours += 1
                self.minutes = 0
            }
        }
    }
    
    func nextAction2(nc: UINavigationController?) {
        nc?.pushViewController(DaftarPresensiVC(), animated: true)
    }
    
    func nextAction(nc: UINavigationController?) {
        nc?.popViewController(animated: true)
    }
    
    func preparePresence(navigationController: UINavigationController?) {
        isLoading.accept(true)
        
        networking.preparePresence { (error, presensi, isExpired) in
            self.isLoading.accept(false)
            
            if let _ = isExpired {
                self.forceLogout(navigationController: navigationController)
                return
            }
            
            if let _error = error {
                if _error == self.constant.CONNECTION_ERROR {
                    if self.preparePresenceLimit <= 3 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.preparePresenceLimit += 1
                            self.preparePresence(navigationController: navigationController)
                        }
                    } else {
                        self.preparePresenceLimit = 1
                        self.showDelegateDialogAlert(image: nil, delegate: self, content: _error, nc: navigationController)
                    }
                } else {
                    self.showDelegateDialogAlertWithAction2(image: nil, action2String: "presence_list".localize(), delegate: self, content: _error, nc: navigationController)
                }
                return
            }
            
            guard let _presence = presensi, let _data = _presence.data else { return }
            
            if _presence.status {
                self.preparePresenceLimit = 1
                self.presenceTime(time: _presence.data?.server_time ?? "", timeZone: _presence.data?.timezone_code ?? "")
                self.presence.accept(_data)
                self.message.accept(_presence.messages[0])
            } else {
                self.showDelegateDialogAlertWithAction2(image: nil, action2String: "presence_list".localize(), delegate: self, content: _presence.messages[0], nc: navigationController)
            }
        }
    }
}
