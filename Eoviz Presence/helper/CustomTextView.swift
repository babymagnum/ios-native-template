//
//  CustomTextView.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 13/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var fontSize: CGFloat = 16 { didSet { updateFonts() }}
    @IBInspectable var fontName: String = "Poppins-Medium" { didSet { updateFonts() }}
    
    func updateFonts() {
        font = UIFont(name: fontName, size: fontSize + PublicFunction.dynamicSize())
    }
}
