//
//  RiwayatIzinCutiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import RxSwift
import DIKit

class RiwayatIzinCutiVC: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var collectionRiwayatIzinCuti: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    @Inject private var filterRiwayatIzinCutiVM: FilterRiwayatIzinCutiVM
    @Inject private var riwayatIzinCutiVM: RiwayatIzinCutiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterRiwayatIzinCutiVM.resetFilterRiwayatIzinCuti()
        
        setupView()
        
        observeData()
        
        riwayatIzinCutiVM.getRiwayatIzinCuti(isFirst: true, nc: navigationController)
    }
    
    private func observeData() {
        riwayatIzinCutiVM.emptyMessage.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
        
        riwayatIzinCutiVM.showEmpty.subscribe(onNext: { value in
            self.viewEmpty.isHidden = !value
        }).disposed(by: disposeBag)
        
        riwayatIzinCutiVM.isLoading.subscribe(onNext: { _ in
            self.collectionRiwayatIzinCuti.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
        riwayatIzinCutiVM.listRiwayatIzinCuti.subscribe(onNext: { _ in
            self.collectionRiwayatIzinCuti.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionRiwayatIzinCuti.register(UINib(nibName: "RiwayatIzinCutiCell", bundle: .main), forCellWithReuseIdentifier: "RiwayatIzinCutiCell")
        collectionRiwayatIzinCuti.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionRiwayatIzinCuti.delegate = self
        collectionRiwayatIzinCuti.dataSource = self
        collectionRiwayatIzinCuti.addSubview(refreshControl)
    }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        riwayatIzinCutiVM.getRiwayatIzinCuti(isFirst: true, nc: navigationController)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension RiwayatIzinCutiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == riwayatIzinCutiVM.listRiwayatIzinCuti.value.count - 1 {
            riwayatIzinCutiVM.getRiwayatIzinCuti(isFirst: false, nc: navigationController)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riwayatIzinCutiVM.listRiwayatIzinCuti.value.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == riwayatIzinCutiVM.listRiwayatIzinCuti.value.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.isHidden = !riwayatIzinCutiVM.isLoading.value
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RiwayatIzinCutiCell", for: indexPath) as! RiwayatIzinCutiCell
            cell.data = riwayatIzinCutiVM.listRiwayatIzinCuti.value[indexPath.item]
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellRiwayatTukarShiftClick(sender:))))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == riwayatIzinCutiVM.listRiwayatIzinCuti.value.count {
            return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
        } else {
            let item = riwayatIzinCutiVM.listRiwayatIzinCuti.value[indexPath.item]
            let viewStatusSize = (screenWidth - 60) * 0.2
            let textWidth = screenWidth - 98 - viewStatusSize
            let nomerHeight = item.permission_number?.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let reasonHeight = item.permission_reason?.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let cutiDateHeight = item.date?.getHeight(withConstrainedWidth: textWidth, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
            return CGSize(width: screenWidth - 60, height: nomerHeight + reasonHeight + cutiDateHeight + 29)
        }
    }
}

extension RiwayatIzinCutiVC: FilterRiwayatIzinCutiProtocol {
    func applyFilter() {
        riwayatIzinCutiVM.getRiwayatIzinCuti(isFirst: true, nc: navigationController)
    }
    
    private func navigateToIzinCutiVC(permissionId: String?) {
        let vc = IzinCutiVC()
        vc.permissionId = permissionId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cellRiwayatTukarShiftClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionRiwayatIzinCuti.indexPathForItem(at: sender.location(in: collectionRiwayatIzinCuti)) else { return }
        
        let item = riwayatIzinCutiVM.listRiwayatIzinCuti.value[indexpath.item]
        
        if item.permission_status ?? 0 == 0 {
            let izinCutiVC = navigationController?.viewControllers.last(where: { $0.isKind(of: IzinCutiVC.self) })
            
            if let _izinCutiVC = izinCutiVC {
                let removedIndex = navigationController?.viewControllers.lastIndex(of: _izinCutiVC)
                
                navigationController?.viewControllers.remove(at: removedIndex ?? 0)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.navigateToIzinCutiVC(permissionId: item.permission_id)
                }
            } else {
                self.navigateToIzinCutiVC(permissionId: item.permission_id)
            }
        } else {
            let vc = DetailIzinCutiVC()
            vc.permissionId = item.permission_id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterRiwayatIzinCutiVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
