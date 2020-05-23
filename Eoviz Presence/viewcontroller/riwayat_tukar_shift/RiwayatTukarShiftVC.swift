//
//  RiwayatTukarShiftVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class RiwayatTukarShiftVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionRiwayatTukarShift: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    @Inject private var filterRiwayatTukarShiftVM: FilterRiwayatTukarShiftVM
    @Inject private var riwayatTukarShiftVM: RiwayatTukarShiftVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterRiwayatTukarShiftVM.resetFilterRiwayatTukarShift()
        
        setupView()
        
        observeData()
        
        riwayatTukarShiftVM.getRiwayatTukarShift(isFirst: true, nc: navigationController)
    }
    
    private func observeData() {
        riwayatTukarShiftVM.showEmpty.subscribe(onNext: { value in
            self.viewEmpty.isHidden = !value
        }).disposed(by: disposeBag)
        
        riwayatTukarShiftVM.isLoading.subscribe(onNext: { _ in
            self.collectionRiwayatTukarShift.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
        riwayatTukarShiftVM.listRiwayatTukarShift.subscribe(onNext: { _ in
            self.collectionRiwayatTukarShift.reloadData()
        }).disposed(by: disposeBag)
        
        riwayatTukarShiftVM.emptyMessage.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionRiwayatTukarShift.register(UINib(nibName: "RiwayatTukarShiftCell", bundle: .main), forCellWithReuseIdentifier: "RiwayatTukarShiftCell")
        collectionRiwayatTukarShift.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionRiwayatTukarShift.delegate = self
        collectionRiwayatTukarShift.dataSource = self
        collectionRiwayatTukarShift.addSubview(refreshControl)
    }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        riwayatTukarShiftVM.getRiwayatTukarShift(isFirst: true, nc: navigationController)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension RiwayatTukarShiftVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == riwayatTukarShiftVM.listRiwayatTukarShift.value.count - 1 {
            riwayatTukarShiftVM.getRiwayatTukarShift(isFirst: false, nc: navigationController)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riwayatTukarShiftVM.listRiwayatTukarShift.value.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == riwayatTukarShiftVM.listRiwayatTukarShift.value.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.isHidden = !riwayatTukarShiftVM.isLoading.value
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiwayatTukarShiftCell", for: indexPath) as! RiwayatTukarShiftCell
            cell.data = riwayatTukarShiftVM.listRiwayatTukarShift.value[indexPath.item]
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellRiwayatTukarShiftClick(sender:))))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == riwayatTukarShiftVM.listRiwayatTukarShift.value.count {
            return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
        } else {
            let item = riwayatTukarShiftVM.listRiwayatTukarShift.value[indexPath.item]
            let content = "\("exchange_shift_request".localize()) \(item.exchange_emp_name ?? "")."
            let viewStatusSize = (screenWidth - 60) * 0.2
            let textWidth = screenWidth - 98 - viewStatusSize
            let nomerHeight = item.exchange_number?.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let contentHeight = content.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize()))
            let tukarShiftDateHeight = item.exchange_date_shift_name?.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
            return CGSize(width: screenWidth - 60, height: nomerHeight + contentHeight + tukarShiftDateHeight + 29)
        }
    }
}

extension RiwayatTukarShiftVC: FilterRiwayatTukarShiftProtocol {
    func updateData() {
        riwayatTukarShiftVM.getRiwayatTukarShift(isFirst: true, nc: navigationController)
    }
    
    @objc func cellRiwayatTukarShiftClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionRiwayatTukarShift.indexPathForItem(at: sender.location(in: collectionRiwayatTukarShift)) else { return }
        
        let item = riwayatTukarShiftVM.listRiwayatTukarShift.value[indexpath.item]
        
        if item.exchange_status == 0 {
            let vc = TukarShiftVC()
            vc.shiftExchangeId = item.exchange_id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailPengajuanTukarShiftVC()
            vc.shiftExchangeId = item.exchange_id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterRiwayatTukarShiftVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
