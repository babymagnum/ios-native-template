//
//  SplashVM.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SplashVM {
    var test = BehaviorSubject<String>(value: "test1")
    
    func setTest(value: String) { test.onNext(value) }
}
