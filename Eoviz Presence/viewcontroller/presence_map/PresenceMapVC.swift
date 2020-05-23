//
//  PresenceMapVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import GoogleMaps
import DIKit
import RxSwift
import SVProgressHUD

class PresenceMapVC: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelShift: CustomLabel!
    @IBOutlet weak var viewPresenceParent: UIView!
    @IBOutlet weak var buttonTime: CustomButton!
    @IBOutlet weak var buttonOnTheZone: CustomButton!
    @IBOutlet weak var viewPresence: CustomGradientView!
    @IBOutlet weak var labelJamMasuk: CustomLabel!
    @IBOutlet weak var labelJamKeluar: CustomLabel!
    @IBOutlet weak var viewPresenseHeight: CustomMargin!
    @IBOutlet weak var viewOutsideTheZoneHeight: CustomMargin!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewOutsideTheZone: CustomView!
    @IBOutlet weak var labelPresence: CustomLabel!
    
    private var locationManager: CLLocationManager = CLLocationManager()
    @Inject private var presenceMapVM: PresenceMapVM
    @Inject private var presensiVM: PresensiVM
    private var disposeBag = DisposeBag()
    private var currentLocation = CLLocation()
    private var marker: GMSMarker?
    private var circles = [Circle]()
    private var pickedCheckpointId = 0
    
    var presenceData: PresensiData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        observeData()
        
        drawCircle()
        
        initLocationManager()
        
        setupEvent()
    }
    
    private func setupView() {
        self.viewOutsideTheZoneHeight.constant = 0
        self.viewOutsideTheZone.alpha = 0
    }
    
    private func setupEvent() {
        viewPresence.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPresenceClick)))
    }
    
    private func observeData() {
        presensiVM.time.subscribe(onNext: { value in
            self.buttonTime.setTitle(value, for: .normal)
        }).disposed(by: disposeBag)
        
        presensiVM.presence.subscribe(onNext: { data in
            self.labelJamMasuk.text = data.presence_shift_start ?? ""
            self.labelJamKeluar.text = data.presence_shift_end ?? ""
            self.labelShift.text = (data.shift_name ?? "").capitalizingFirstLetter()
            self.labelPresence.text = data.is_presence_in ?? false ? "presence_out".localize() : "presence_in".localize()
        }).disposed(by: disposeBag)
        
        presenceMapVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        //this line of code below to prompt the user for location permission
        locationManager.requestWhenInUseAuthorization()
        //this line of code below to set the range of the accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //this line of code below to start updating the current location
        locationManager.startUpdatingLocation()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    func updateLocationCoordinates(coordinates: CLLocationCoordinate2D) {
        if let _marker = marker {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            _marker.position =  coordinates
            CATransaction.commit()
        } else {
            marker = GMSMarker()
            marker?.position = coordinates
            marker?.icon = UIImage(named: "rectangle23")
            marker?.map = mapView
            marker?.appearAnimation = .pop
        }
    }
    
    private func circleInsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.peacockBlue.withAlphaComponent(0.4)
        circle.strokeColor = UIColor.peacockBlue.withAlphaComponent(0.4)
        circle.strokeWidth = 1
    }
    
    private func circleOutsideRadius(circle: GMSCircle) {
        circle.fillColor = UIColor.rustRed.withAlphaComponent(0.4)
        circle.strokeColor = UIColor.rustRed.withAlphaComponent(0.4)
        circle.strokeWidth = 1
    }
    
    func addRadiusCircle(circle: Circle, isInside: Bool, isUpdate: Bool){
        
        if isInside {
            self.pickedCheckpointId = circle.checkpoint_id
            circleInsideRadius(circle: circle.circle)
        } else {
            circleOutsideRadius(circle: circle.circle)
        }
        
        if !isUpdate {
            circle.circle.map = mapView
        }
    }
    
    private func checkDistance(_ currentLocation: CLLocation) {
        for circle in circles {
            print(circle.checkpoint_id)
            let buildingLat = circle.circle.position.latitude
            let buildingLon = circle.circle.position.longitude
            let radius = circle.circle.radius + 5
            
            let distance = currentLocation.distance(from: CLLocation(latitude: buildingLat, longitude: buildingLon))
            
            if distance <= radius {
                self.showPressence()
                self.addRadiusCircle(circle: circle, isInside: true, isUpdate: true)
                break
            } else {
                self.hidePressence()
                self.addRadiusCircle(circle: circle, isInside: false, isUpdate: true)
            }
        }
    }
    
    private func showPressence() {
        UIView.animate(withDuration: 0.2) {
            //self.buttonOnTheZone.isHidden = false
            //self.viewPresenseHeight.constant = self.screenWidth * 0.11
            //self.viewPresence.alpha = 1
            //self.viewOutsideTheZoneHeight.constant = 0
            //self.viewOutsideTheZone.alpha = 0
            self.buttonOnTheZone.setTitleColor(UIColor.windowsBlue, for: .normal)
            self.viewPresence.startColor = UIColor.peacockBlue.withAlphaComponent(0.8)
            self.viewPresence.endColor = UIColor.greyblue.withAlphaComponent(0.8)
            self.labelPresence.textColor = UIColor.white
            self.buttonOnTheZone.setTitle("youre_in_the_zone".localize(), for: .normal)
            self.viewPresence.isUserInteractionEnabled = true
            self.viewPresenceParent.layoutIfNeeded()
        }
    }
    
    private func hidePressence() {
        UIView.animate(withDuration: 0.2) {
            //self.buttonOnTheZone.isHidden = true
            //self.viewPresence.alpha = 0
            //self.viewPresenseHeight.constant = 0
            //self.viewOutsideTheZoneHeight.constant = self.screenWidth * 0.5
            //self.viewOutsideTheZone.alpha = 1
            self.buttonOnTheZone.setTitleColor(UIColor.pastelRed, for: .normal)
            self.viewPresence.startColor = UIColor.veryLightPinkFour
            self.viewPresence.endColor = UIColor.paleGrey
            self.labelPresence.textColor = UIColor.brownGreyThree
            self.buttonOnTheZone.setTitle("youre_out_the_zone".localize(), for: .normal)
            self.viewPresence.isUserInteractionEnabled = false
            self.viewPresenceParent.layoutIfNeeded()
        }
    }
    
    private func drawCircle() {
        for checkpoint in presenceData.presence_zone {
            let buildingLat = Double(checkpoint.preszone_latitude ?? "0") ?? 0
            let buildingLon = Double(checkpoint.preszone_longitude ?? "0") ?? 0
            let circlePosition = CLLocationCoordinate2D(latitude: buildingLat, longitude: buildingLon)
            let stringRadius = checkpoint.preszone_radius?.components(separatedBy: ".")
            guard let nnRadius = stringRadius else {
                return
            }
            let radius = Double(nnRadius[0])!

            let circle = Circle(checkpoint_id: checkpoint.preszone_id ?? 0, circle: GMSCircle(position: circlePosition, radius: radius))
            self.circles.append(circle)

            self.addRadiusCircle(circle: circle, isInside: false, isUpdate: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            currentLocation = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
            updateLocationCoordinates(coordinates: location.coordinate)
            mapView.animate(to: GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: Float(self.presenceData.zoom_maps ?? 17)))
            checkDistance(currentLocation)
        }
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func viewPresenceClick() {
        presenceMapVM.presence(presenceId: "\(pickedCheckpointId)", presenceType: presenceData.is_presence_in ?? false ? "out" : "in", latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, navigationController: navigationController)
    }
}
