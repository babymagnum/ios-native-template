//
//  CustomGradientView.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 09/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

@IBDesignable
class CustomGradientView: UIView {

    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() }}
    @IBInspectable var borderRadius: CGFloat = 0 { didSet { updateRadius() }}
    @IBInspectable var isRoundedAllCorner: Bool = false { didSet { updateRadius() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    func updateRadius() {
        if isRoundedAllCorner {
            layer.cornerRadius = frame.height / 2
        } else {
            layer.cornerRadius = borderRadius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateRadius()
        updateColors()
        updateLocations()
        updatePoints()
    }
}
