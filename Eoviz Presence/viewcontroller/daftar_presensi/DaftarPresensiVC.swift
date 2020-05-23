//
//  DaftarPresensiVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD

class DaftarPresensiVC: BaseViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionPresensi: UICollectionView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var labelEmpty: CustomLabel!
    
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    @Inject private var daftarPresensiVM: DaftarPresensiVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterDaftarPresensiVM.resetFilterDaftarPresensi()
        
        setupView()
        
        observeData()
        
        getData()
        
        removePresenceVC()
    }
    
    private func removePresenceVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let presenceVC = self.navigationController?.viewControllers.last(where: { $0.isKind(of: PresensiVC.self) }) else { return }
            let index = self.navigationController?.viewControllers.firstIndex(of: presenceVC) ?? 0
            self.navigationController?.viewControllers.remove(at: index)
        }
    }
    
    private func getData() {
        let date = "\(filterDaftarPresensiVM.tahun.value)-\(filterDaftarPresensiVM.bulan.value)"
        daftarPresensiVM.getListPresensi(date: date, nc: navigationController)
    }
    
    private func observeData() {
        daftarPresensiVM.listPresensi.subscribe(onNext: { value in
            self.collectionPresensi.reloadData()
            
            if value.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    let todayIndex = value.firstIndex(where: { (item) -> Bool in
                        let today = PublicFunction.getStringDate(pattern: "EEEE, dd MMMM yyyy")
                        return item.presence_date == today
                    }) ?? 0
                    
                    self.collectionPresensi.scrollToItem(at: IndexPath(item: todayIndex, section: 0), at: .centeredVertically, animated: true)
                }
            }
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.labelEmpty.subscribe(onNext: { value in
            self.labelEmpty.text = value
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.showEmpty.subscribe(onNext: { value in
            self.viewEmpty.isHidden = !value
        }).disposed(by: disposeBag)
        
        daftarPresensiVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewParent.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        collectionPresensi.register(UINib(nibName: "DaftarPresensiCell", bundle: .main), forCellWithReuseIdentifier: "DaftarPresensiCell")
        collectionPresensi.delegate = self
        collectionPresensi.dataSource = self
        collectionPresensi.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        let date = "\(self.filterDaftarPresensiVM.tahun.value)-\(self.filterDaftarPresensiVM.bulan.value)"
        daftarPresensiVM.getListPresensi(date: date, nc: navigationController)
    }
}

extension DaftarPresensiVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daftarPresensiVM.listPresensi.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaftarPresensiCell", for: indexPath) as! DaftarPresensiCell
        cell.data = daftarPresensiVM.listPresensi.value[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = daftarPresensiVM.listPresensi.value[indexPath.item]
        let marginHorizontal: CGFloat = 60 - 26
        let dateHeight = item.presence_date?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Regular", size: 12 + PublicFunction.dynamicSize())) ?? 0
        let shiftHeight = item.presence_shift_name?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 10 + PublicFunction.dynamicSize())) ?? 0
        let statusHeight = item.prestype_name?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 9 + PublicFunction.dynamicSize())) ?? 0
        let jamMasukHeight = item.presence_in?.getHeight(withConstrainedWidth: screenWidth - marginHorizontal, font: UIFont(name: "Poppins-Medium", size: 12 + PublicFunction.dynamicSize())) ?? 0
        return CGSize(width: screenWidth - 60, height: dateHeight + statusHeight + shiftHeight + (jamMasukHeight * 2) + 49 + 6 /* 6 is additional height for button status */)
    }
}

extension DaftarPresensiVC: FilterDaftarPresensiProtocol {
    func applyFilter() {
        let date = "\(filterDaftarPresensiVM.tahun.value)-\(filterDaftarPresensiVM.bulan.value)"
        self.daftarPresensiVM.getListPresensi(date: date, nc: self.navigationController)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterDaftarPresensiVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
