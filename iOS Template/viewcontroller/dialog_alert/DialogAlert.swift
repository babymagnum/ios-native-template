//
//  DialogAlert.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 08/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

protocol DialogAlertProtocol {
    func nextAction(nc: UINavigationController?)
    func nextAction2(nc: UINavigationController?)
}

class DialogAlert: BaseViewController {
    
    @IBOutlet weak var labelDescription: CustomLabel!
    @IBOutlet weak var imageX: UIImageView!
    @IBOutlet weak var viewAction1: CustomGradientView!
    @IBOutlet weak var viewAction2: CustomGradientView!
    @IBOutlet weak var labelAction1: CustomLabel!
    @IBOutlet weak var labelAction2: CustomLabel!
    @IBOutlet weak var viewAction1MarginBottom: NSLayoutConstraint!
    @IBOutlet weak var viewAction2Height: CustomMargin!
    
    var stringDescription: String?
    var image: String?
    var delegate: DialogAlertProtocol?
    var nc: UINavigationController?
    var action2String: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }
    
    private func setupEvent() {
        viewAction1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAction1Click)))
        viewAction2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAction2Click)))
    }
    
    private func setupView() {
        labelAction1.text = "understand".localize()
        if let _action2String = action2String {
            labelAction2.text = _action2String
            viewAction2.giveBorder(1, UIColor.windowsBlue)
        } else {
            viewAction1MarginBottom.constant = 0
            viewAction2Height.multi = 0
        }
        labelDescription.text = stringDescription
        if let _image = image {
            imageX.image = UIImage(named: _image)
        }
    }

    @objc func viewAction1Click() {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.nextAction(nc: nc)
    }

    @objc func viewAction2Click() {
        self.dismiss(animated: true, completion: nil)
        
        delegate?.nextAction2(nc: nc)
    }
    
}
