//
//  NotificationVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift

class NotificationVC: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var viewParent: CustomView!
    @IBOutlet weak var collectionNotifikasi: UICollectionView!
    @IBOutlet weak var viewEmptyNotifikasi: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    @Inject var notificationVM: NotificationVM
    @Inject var profileVM: ProfileVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        observeData()
        
        notificationVM.getNotifikasi(isFirst: true, nc: navigationController)
    }

    private func observeData() {
        notificationVM.emptyNotification.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
        
        notificationVM.showEmpty.subscribe(onNext: { value in
            self.viewEmptyNotifikasi.isHidden = !value
        }).disposed(by: disposeBag)
        
        notificationVM.isLoading.subscribe(onNext: { _ in
            self.collectionNotifikasi.collectionViewLayout.invalidateLayout()
        }).disposed(by: disposeBag)
        
        notificationVM.listNotifikasi.subscribe(onNext: { _ in
            self.collectionNotifikasi.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionNotifikasi.register(UINib(nibName: "NotifikasiCell", bundle: .main), forCellWithReuseIdentifier: "NotifikasiCell")
        collectionNotifikasi.register(UINib(nibName: "LoadingCell", bundle: .main), forCellWithReuseIdentifier: "LoadingCell")
        collectionNotifikasi.delegate = self
        collectionNotifikasi.dataSource = self
        collectionNotifikasi.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        notificationVM.getNotifikasi(isFirst: true, nc: navigationController)
    }
}

extension NotificationVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == notificationVM.listNotifikasi.value.count - 1 {
            notificationVM.getNotifikasi(isFirst: false, nc: navigationController)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationVM.listNotifikasi.value.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == notificationVM.listNotifikasi.value.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.isHidden = !notificationVM.isLoading.value
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotifikasiCell", for: indexPath) as! NotifikasiCell
            cell.data = notificationVM.listNotifikasi.value[indexPath.item]
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellNotificationClick(sender:))))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == notificationVM.listNotifikasi.value.count {
            return CGSize(width: screenWidth - 60, height: (screenWidth - 60) * 0.1)
        } else {
            let item = notificationVM.listNotifikasi.value[indexPath.item]
            let dateHeight = item.notification_date?.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: "Roboto-Medium", size: 11 + PublicFunction.dynamicSize())) ?? 0
            let titleHeight = item.notification_title?.getHeight(withConstrainedWidth: screenWidth - 60 - 34 - 18, font: UIFont(name: item.notification_is_read ?? 0 == 1 ? "Poppins-Regular" : "Poppins-SemiBold", size: 12 + PublicFunction.dynamicSize())) ?? 0
            let contentHeight = item.notification_content?.getHeight(withConstrainedWidth: screenWidth - 60 - 34, font: UIFont(name: item.notification_is_read ?? 0 == 1 ? "Poppins-Regular" : "Poppins-SemiBold", size: 11 + PublicFunction.dynamicSize())) ?? 0
            return CGSize(width: screenWidth - 60, height: dateHeight + titleHeight + contentHeight + 34)
        }
    }
}

extension NotificationVC {
    @objc func cellNotificationClick(sender: UITapGestureRecognizer) {
        guard let indexpath = collectionNotifikasi.indexPathForItem(at: sender.location(in: collectionNotifikasi)) else { return }
        
        let item = notificationVM.listNotifikasi.value[indexpath.item]
        
        notificationVM.updateNotificationRead(index: indexpath.item, notificationId: item.notification_id ?? "", nc: navigationController)
        
        if item.notification_redirect ?? "" == "leave_detail" {
            let vc = DetailIzinCutiVC()
            vc.permissionId = item.notification_data_id
            navigationController?.pushViewController(vc, animated: true)
        } else if item.notification_redirect ?? "" == "leave_approve_detail" {
            let vc = DetailPersetujuanIzinCutiVC()
            vc.leaveId = item.notification_data_id
            navigationController?.pushViewController(vc, animated: true)
        } else if item.notification_redirect ?? "" == "exchange_shift_detail" {
            let vc = DetailPengajuanTukarShiftVC()
            vc.shiftExchangeId = item.notification_data_id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = DetailPersetujuanTukarShiftVC()
            vc.shiftExchangeId = item.notification_data_id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
