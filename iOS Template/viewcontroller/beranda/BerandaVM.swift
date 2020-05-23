//
//  BerandaVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxRelay

class BerandaVM: BaseViewModel {
    private var seconds = 0
    private var minutes = 0
    private var hours = 0
    private var timer: Timer?
        
    var isLoading = BehaviorRelay(value: false)
    var time = BehaviorRelay(value: "")
    
    func startTime() {
        if let _timer = timer {
            _timer.invalidate()
        }
        
        let timeArray = PublicFunction.getStringDate(pattern: "HH:mm:ss").components(separatedBy: ":")
        
        seconds = Int(timeArray[2])!
        minutes = Int(timeArray[1])!
        hours = Int(timeArray[0])!

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            if self.time.value.count >= 12 && self.time.value.substring(toIndex: 5) != PublicFunction.getStringDate(pattern: "HH:mm") { self.startTime() }
            
            self.seconds += 1
            
            let time = "\(String(self.hours).count == 1 ? "0\(self.hours)" : "\(self.hours == 24 ? "00" : String(self.hours))"):\(String(self.minutes).count == 1 ? "0\(self.minutes)" : "\(self.minutes == 60 ? "00" : String(self.minutes))"):\(String(self.seconds).count == 1 ? "0\(self.seconds)" : "\(self.seconds == 60 ? "00" : String(self.seconds))") WIB"
            
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
    
}
