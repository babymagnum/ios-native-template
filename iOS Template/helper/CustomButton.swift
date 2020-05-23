//
//  CustomButton.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 12/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var fontName: String = "Poppins-Medium" { didSet { updateFonts() }}
    @IBInspectable var fontSize: CGFloat = 16 { didSet { updateFonts() }}
    @IBInspectable var borderRadius: CGFloat = 10 { didSet { updateFonts() }}
    @IBInspectable var isAllRounded: Bool = false { didSet { updateFonts() }}
    @IBInspectable var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight] { didSet { updateFonts() }}
    
    func updateFonts() {
        titleLabel?.font = UIFont(name: fontName, size: fontSize + PublicFunction.dynamicSize())
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: borderRadius, height: borderRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        if isAllRounded {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFonts()
    }
}
