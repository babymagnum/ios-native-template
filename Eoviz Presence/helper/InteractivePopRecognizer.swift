//
//  InteractiveRecognizer.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 18/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
    
    private var preference = Preference()
    private var constant = Constant()
    
    var navigationController: UINavigationController
    
    init(controller: UINavigationController) {
        self.navigationController = controller
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // isSetupLanguage ada variabel untuk mengetahui apabila user setelah login, apabila isSetupLanguage true maka dia masuk dari LoginVC, dan apabila false dia masuk dari splashController
        let isSetupLanguage = preference.getBool(key: constant.IS_SETUP_LANGUAGE)
        return navigationController.viewControllers.count > (isSetupLanguage ? 1 : 2)
    }
    
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
