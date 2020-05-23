//
//  CustomLabel.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 11/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var fontName: String = "Poppins-Medium" { didSet { updateFonts() }}
    @IBInspectable var fontSize: CGFloat = 16 { didSet { updateFonts() }}
    
    func updateFonts() {
        font = UIFont(name: fontName, size: fontSize + PublicFunction.dynamicSize())
    }
}
