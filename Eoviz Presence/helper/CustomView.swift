//
//  CustomView.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 09/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var borderRadius: CGFloat = 16 { didSet { updateView() }}
    @IBInspectable var useShadow: Bool = false { didSet { updateView() }}
    @IBInspectable var isRoundedAllCorner: Bool = false { didSet { updateView() }}
    @IBInspectable var giveBorder: Bool = false { didSet { updateView() }}
    @IBInspectable var borderWidth: CGFloat = 1 { didSet { updateView() }}
    @IBInspectable var borderColor: UIColor = UIColor.blue { didSet { updateView() }}
    @IBInspectable var useCustomCorner: Bool = false { didSet { updateView() }}
    
    func updateView() {
        if isRoundedAllCorner {
            layer.cornerRadius = frame.height / 2
        } else {
            layer.cornerRadius = borderRadius
        }
        
        if useShadow {
            addShadow(CGSize(width: 1, height: 4), UIColor.black.withAlphaComponent(0.2), 3, 1)
        }
        
        if giveBorder {
            giveBorder(1, borderColor)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
}
