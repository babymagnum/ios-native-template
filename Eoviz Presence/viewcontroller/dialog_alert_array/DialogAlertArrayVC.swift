//
//  DialogAlertArrayVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 22/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit

class DialogAlertArrayVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionError: UICollectionView!
    @IBOutlet weak var collectionErrorHeight: NSLayoutConstraint!
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var viewAction1: CustomGradientView!
    @IBOutlet weak var labelAction1: CustomLabel!
    
    var listException = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupEvent()
    }
    
    private func setupEvent() {
        viewAction1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAction1Click)))
    }
    
    private func setupView() {
        labelAction1.text = "understand".localize()
        
        collectionError.register(UINib(nibName: "ExceptionCell", bundle: .main), forCellWithReuseIdentifier: "ExceptionCell")
        collectionError.dataSource = self
        collectionError.delegate = self
        
        collectionError.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.2) {
                self.collectionErrorHeight.constant = self.collectionError.contentSize.height
                self.viewParent.layoutIfNeeded()
            }
        }
    }

    @objc func viewAction1Click() {
        dismiss(animated: true, completion: nil)
    }
}

extension DialogAlertArrayVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listException.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExceptionCell", for: indexPath) as! ExceptionCell
        cell.labelException.text = listException[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = listException[indexPath.item]
        let contentHeight = item.getHeight(withConstrainedWidth: screenWidth - 60 - 40 - 18, font: UIFont(name: "Poppins-Medium", size: 16 + PublicFunction.dynamicSize()))
        return CGSize(width: screenWidth - 60 - 40, height: contentHeight)
    }
}
