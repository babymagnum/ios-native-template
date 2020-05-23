//
//  BerandaCell.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class BerandaCell: BaseCollectionViewCell {

    @IBOutlet weak var viewParent: CustomGradientView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelContent: CustomLabel!
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var labelPercentageContent: CustomLabel!
    
    var data: BerandaCarousel? {
        didSet {
            if let _data = data {
                labelContent.text = _data.content
                image.image = UIImage(named: _data.image)
                labelPercentageContent.text = "\(_data.percentageContent.components(separatedBy: ".")[0])\(_data.content == "leave_nquota".localize() ? "" : "%")"
                addPercentageView(data: _data)
            }
        }
    }
    
    var position: Int?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _position = position {
            viewParent.startColor = _position == 0 ? UIColor.peacockBlue.withAlphaComponent(0.8) : UIColor.greenBlue.withAlphaComponent(0.8)
            viewParent.endColor = _position == 0 ? UIColor.greyblue.withAlphaComponent(0.8) : UIColor.tiffanyBlue.withAlphaComponent(0.8)
        }
    }
    
    func addPercentageView(data: BerandaCarousel) {
        // round view
        let roundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.22, height: screenWidth * 0.22))
        roundView.backgroundColor = UIColor.clear
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        
        // bezier path
        let circlePath = UIBezierPath(
            arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
            radius: roundView.frame.size.width / 2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )

        let percentageCircleShape = CAShapeLayer()
        percentageCircleShape.path = circlePath.cgPath
        percentageCircleShape.strokeColor = position ?? 0 == 0 ? UIColor.white.cgColor : UIColor.darkSlateBlue.cgColor
        percentageCircleShape.fillColor = UIColor.clear.cgColor
        percentageCircleShape.lineWidth = 8
        percentageCircleShape.strokeStart = 0.0
        percentageCircleShape.strokeEnd = CGFloat(data.percentage)
        
        let fullCircleShape = CAShapeLayer()
        fullCircleShape.path = circlePath.cgPath
        fullCircleShape.strokeColor = position ?? 0 == 0 ? UIColor.darkSlateBlue.cgColor : UIColor.white.cgColor
        fullCircleShape.fillColor = UIColor.clear.cgColor
        fullCircleShape.lineWidth = 8
        fullCircleShape.strokeStart = 0.0
        fullCircleShape.strokeEnd = 1.0

        // add sublayer
        roundView.layer.addSublayer(fullCircleShape)
        roundView.layer.addSublayer(percentageCircleShape)
        // add subview
        viewPercentage.addSubview(roundView)
    }
}
