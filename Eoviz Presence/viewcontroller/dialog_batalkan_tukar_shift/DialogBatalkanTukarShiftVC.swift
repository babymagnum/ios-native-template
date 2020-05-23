//
//  DialogBatalkanTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift

protocol DialogBatalkanTukarShiftProtocol {
    func cancelTukarShift(alasan: String)
}

class DialogBatalkanTukarShiftVC: BaseViewController {

    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewKembali: CustomGradientView!
    @IBOutlet weak var viewBatalkan: CustomGradientView!
    
    var delegate: DialogBatalkanTukarShiftProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvent()
    }

    private func setupEvent() {
        viewKembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKembaliClick)))
        viewBatalkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBatalkanClick)))
    }
}

extension DialogBatalkanTukarShiftVC {
    @objc func viewKembaliClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewBatalkanClick() {
        if textviewAlasan.text.trim() == "" {
            self.view.makeToast("empty_reason".localize())
        } else {
            dismiss(animated: true, completion: nil)
            delegate?.cancelTukarShift(alasan: textviewAlasan.text.trim())
        }
    }
}
