//
//  BerandaVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 10/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit
import RxSwift
import SVProgressHUD
import GoogleMaps

class BerandaVC: BaseViewController, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageUser: CustomImage!
    @IBOutlet weak var viewCornerParent: CustomView!
    @IBOutlet weak var labelName: CustomLabel!
    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var labelPresenceStatus: CustomLabel!
    @IBOutlet weak var labelTime: CustomLabel!
    @IBOutlet weak var collectionData: UICollectionView!
    @IBOutlet weak var viewPresensi: UIView!
    @IBOutlet weak var viewTukarShift: UIView!
    @IBOutlet weak var viewIzinCuti: UIView!
    @IBOutlet weak var viewJamKerja: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var listLocations = [CLLocation]()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var disposeBag = DisposeBag()
    @Inject private var berandaVM: BerandaVM
    @Inject private var profileVM: ProfileVM
    @Inject private var notificationVM: NotificationVM
    
    var listBerandaData = [
        BerandaCarousel(image: "clock", content: "percentage_npresence".localize(), percentage: 0, percentageContent: ""),
        BerandaCarousel(image: "koper", content: "leave_nquota".localize(), percentage: 0, percentageContent: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        
        setupView()
        
        observeData()
     
        getData()
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        //this line of code below to prompt the user for location permission
        locationManager.requestWhenInUseAuthorization()
        //this line of code below to set the range of the accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //this line of code below to start updating the current location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        SVProgressHUD.show(withStatus: "checking_location".localize())
        addBlurView(view: self.view)
        
        if let _location = locations.last {
            listLocations.append(_location)
        }
        
        if listLocations.count == 6 {
            manager.stopUpdatingLocation()
            removeBlurView(view: self.view)
            SVProgressHUD.dismiss()
            
            var lastLocation: CLLocation?
            
            for (index, item) in listLocations.enumerated() {
                if let _lastLocation = lastLocation {
                    if item == _lastLocation && index > 1 {
                        self.showAlertDialog(image: nil, description: "fake_location".localize())
                    } else {
                        self.navigationController?.pushViewController(PresensiVC(), animated: true)
                        break
                    }
                }
                
                lastLocation = item
            }
        }
    }
    
    private func getData() {
        if notificationVM.listNotifikasi.value.count == 0 {
            notificationVM.updateNotification.accept(true)
        }
        berandaVM.getBerandaData()
        profileVM.getProfileData(navigationController: nil)
    }
    
    private func setupEvent() {
        viewPresensi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresensiClick)))
        viewTukarShift.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTukarShiftClick)))
        viewIzinCuti.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewIzinCutiClick)))
        viewJamKerja.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewJamKerjaClick)))
    }
    
    private func observeData() {
        berandaVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        berandaVM.isExpired.subscribe(onNext: { value in
            if value { self.forceLogout(_navigationController: self.navigationController) }
        }).disposed(by: disposeBag)
        
        berandaVM.error.subscribe(onNext: { value in
            if value != "" {
                self.showAlertDialog(image: nil, description: value)
            }
        }).disposed(by: disposeBag)
        
        profileVM.image.subscribe(onNext: { value in
            if value != UIImage() {
                self.imageUser.image = value
            }
        }).disposed(by: disposeBag)
        
        berandaVM.beranda.subscribe(onNext: { value in
            self.imageUser.loadUrl(value.photo ?? "")
            self.labelName.text = "\("hello".localize()) \(value.emp_name ?? "")"
            self.labelPresenceStatus.text = value.status_presence ?? ""
            self.labelShift.text = (value.shift_name ?? "").capitalizingFirstLetter()
            self.labelTime.text = value.time_presence
            if let _presence = value.presence {
                let isZero = _presence.target == 0 || _presence.achievement == 0
                let percentage = isZero ? 0 : _presence.achievement / _presence.target
                
                self.listBerandaData[0].percentage = percentage
                self.listBerandaData[0].percentageContent = "\(percentage * 100)%"
            }
            if let _leave = value.leave_quota {
                let isZero = _leave.quota == 0 || _leave.used == 0
                
                self.listBerandaData[1].percentage = isZero ? 0 : _leave.used / _leave.quota
                self.listBerandaData[1].percentageContent = "\(_leave.quota)"
            }
            
            self.collectionData.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewCornerParent.roundCorners([.topLeft, .topRight], radius: 50)
    }

    private func setupView() {
        scrollView.addSubview(refreshControl)
        collectionData.register(UINib(nibName: "BerandaCell", bundle: .main), forCellWithReuseIdentifier: "BerandaCell")
        collectionData.delegate = self
        collectionData.dataSource = self
        let collectionDataLayout = collectionData.collectionViewLayout as! UICollectionViewFlowLayout
        collectionDataLayout.itemSize = CGSize(width: screenWidth * 0.7, height: screenWidth * 0.32)
    }
    
    override func _handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        getData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension BerandaVC {
    @objc func viewPresensiClick() {
        #if DEBUG
        navigationController?.pushViewController(PresensiVC(), animated: true)
        #else
        initLocationManager()
        #endif
    }
    
    @objc func viewTukarShiftClick() {
        navigationController?.pushViewController(TukarShiftVC(), animated: true)
    }
    
    @objc func viewIzinCutiClick() {
        navigationController?.pushViewController(IzinCutiVC(), animated: true)
    }
    
    @objc func viewJamKerjaClick() {
        navigationController?.pushViewController(JamKerjaTimVC(), animated: true)
    }
}

extension BerandaVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listBerandaData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BerandaCell", for: indexPath) as! BerandaCell
        cell.position = indexPath.item
        cell.data = listBerandaData[indexPath.item]
        return cell
    }
}
