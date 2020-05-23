//
//  DialogBatalkanIzinCuti.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import Toast_Swift

protocol DialogBatalkanCutiProtocol {
    func actionClick(cancelNotes: String)
}

class DialogBatalkanIzinCutiVC: BaseViewController {

    @IBOutlet weak var textviewAlasan: CustomTextView!
    @IBOutlet weak var viewKembali: CustomGradientView!
    @IBOutlet weak var viewBatalkan: CustomGradientView!
    
    var delegate: DialogBatalkanCutiProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvent()
    }

    private func setupEvent() {
        viewKembali.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewKembaliClick)))
        viewBatalkan.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewBatalkanClick)))
    }

}

extension DialogBatalkanIzinCutiVC {
    @objc func viewKembaliClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func viewBatalkanClick() {
        if textviewAlasan.text.trim() == "" {
            self.view.makeToast("empty_reason".localize())
        } else {
            dismiss(animated: true, completion: nil)
            
            delegate?.actionClick(cancelNotes: textviewAlasan.text.trim())
        }
    }
}
