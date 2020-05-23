//
//  PublicFunction.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Kingfisher

class PublicFunction {
    
    /*
     bottom_right = .layerMaxXMaxYCorner
     bottom_left = .layerMinXMaxYCorner
     top_right = .layerMaxXMinYCorner
     top_left = .layerMinXMinYCorner
     */
    
    let imageCache = NSCache<NSString, UIImage>()
    let imageCacheKey: NSString = "CachedMapSnapshot"
    lazy var preference: Preference = { return Preference() }()
    lazy var constant: Constant = { return Constant() }()
    
    static func setStatusBarBackgroundColor(color: UIColor) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
    }
    
    static func getStraightDistance(latitude: Double, longitude: Double) -> Double{
        let location = CLLocation()
        return location.distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    static func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    return
                }
                
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                }
        })
    }
    
    static func timerConnection() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            print("timer is running")
        }
    }
    
    ///////////////////////////////////////////////////////////////////////
    ///  This function converts decimal degrees to radians              ///
    ///////////////////////////////////////////////////////////////////////
    func deg2rad(deg:Double) -> Double {
        return deg * .pi / 180
    }
    
    ///////////////////////////////////////////////////////////////////////
    ///  This function converts radians to decimal degrees              ///
    ///////////////////////////////////////////////////////////////////////
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / .pi
    }
    
    static func statusBarHeight() -> CGFloat{
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    func cacheImage(image: UIImage) {
        imageCache.setObject(image, forKey: imageCacheKey)
    }
    
    func cachedImage() -> UIImage? {
        return imageCache.object(forKey: imageCacheKey)
    }
    
    open func setShadow(_ view: UIView, _ cornerRadius: CGFloat, _ shadowColor: CGColor, _ width: CGFloat, _ height: CGFloat, _ shadowRadius: CGFloat, _ opacity: Float){
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowColor = shadowColor
        view.layer.shadowOffset = CGSize(width: width, height: height)
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = opacity
    }
    
    open func loadStaticMap(_ latitude: Double, _ longitude: Double, _ metters: Double, _ image: UIImageView, _ markerFileName: String) {
        if let cachedImage = self.cachedImage() {
            image.image = cachedImage
            return
        }
        
        let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let distanceInMeters: Double = metters
        
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coords, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
        options.size = image.frame.size
        
        let bgQueue = DispatchQueue.global(qos: .background)
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start(with: bgQueue, completionHandler: { [weak self] (snapshot, error) in
            guard error == nil else {
                return
            }
            
            if let snapShotImage = snapshot?.image, let coordinatePoint = snapshot?.point(for: coords), let pinImage = UIImage(named: markerFileName) {
                UIGraphicsBeginImageContextWithOptions(snapShotImage.size, true, snapShotImage.scale)
                snapShotImage.draw(at: CGPoint.zero)
                
                let fixedPinPoint = CGPoint(x: coordinatePoint.x - pinImage.size.width / 2, y: coordinatePoint.y - pinImage.size.height)
                pinImage.draw(at: fixedPinPoint)
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                if let unwrappedImage = mapImage {
                    self?.cacheImage(image: unwrappedImage)
                }
                
                DispatchQueue.main.async {
                    image.image = mapImage
                }
                UIGraphicsEndImageContext()
            }
        })
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        
        if (unit == "Kilometer") {
            dist = dist * 1.609344
        }
        else if (unit == "Nautical Miles") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    static func getStringDate(pattern: String) -> String {
        let preference = Preference()
        let formater = DateFormatter()
        formater.dateFormat = pattern
        formater.locale = Locale(identifier: preference.getString(key: Constant().LANGUAGE))
        return formater.string(from: Date())
    }
    
    static func dateStringTo(date: String, fromPattern: String, toPattern: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromPattern
        let showDate = inputFormatter.date(from: date == "" ? getStringDate(pattern: fromPattern) : date) ?? Date()
        inputFormatter.dateFormat = toPattern
        return inputFormatter.string(from: showDate)
    }
    
    static func dateStringTo(date: String, fromPattern: String, toPattern: String, locale: Locale) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = locale
        inputFormatter.dateFormat = fromPattern
        let showDate = inputFormatter.date(from: date == "" ? getStringDate(pattern: fromPattern) : date) ?? Date()
        inputFormatter.dateFormat = toPattern
        return inputFormatter.string(from: showDate)
    }
    
    static func dateToString(_ date: Date, _ pattern: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = pattern
        return dateformatter.string(from: date)
    }
    
    static func dateToMillis(date: Date, pattern: String) -> Double {
        return Double(date.timeIntervalSince1970) * 1000.0
    }
    
    static func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func stringToDate(date: String, pattern: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = pattern
        return dateformatter.date(from: date == "" ? getStringDate(pattern: pattern) : date) ?? Date()
    }
    
    static func changeStatusBar(hexCode: Int, view: UIView, opacity: CGFloat){
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(rgb: hexCode).withAlphaComponent(opacity)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    static func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    static func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String?, _ actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    static func dynamicSize() -> CGFloat {
        if (UIScreen.main.bounds.width == 320) {
            return -1.5
        } else if (UIScreen.main.bounds.width == 375) {
            return -0.5
        } else if (UIScreen.main.bounds.width == 414) {
            return 0
        } else {
            return 0
        }
    }
    
    static func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            completionHandler()
        }))
        viewController.present(alert, animated: true)
    }
    
    static func coloredString(color: String, mainString: String, stringNotColored: String) -> NSMutableAttributedString {
        let range = "{\(mainString.count-stringNotColored.count), \(stringNotColored.count)}"
        let coloredString = NSMutableAttributedString.init(string: mainString)
        coloredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: color) , range: NSRange(range)!)
        return coloredString
    }
    
    static func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionOk: String, _ actionCancel: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionCancel, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: actionOk, style: .default, handler: { (action) in
            completionHandler()
        }))
        viewController.present(alert, animated: true)
    }
    
    static func createQRFromString(_ str: String, size: CGSize) -> UIImage {
        let stringData = str.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        let minimalQRimage = qrFilter.outputImage!
        // NOTE that a QR code is always square, so minimalQRimage..width === .height
        let minimalSideLength = minimalQRimage.extent.width
        
        let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
        let scaleFactor = smallestOutputExtent / minimalSideLength
        let scaledImage = minimalQRimage.transformed(
            by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        return UIImage(ciImage: scaledImage,
                       scale: UIScreen.main.scale,
                       orientation: .up)
    }
    
    static func prettyRupiah(_ money: String) -> String {
        var result = money
        
        switch money.count {
        case 1, 2, 3: //satuan, puluhan, ratusan
            result = money
        case 4: //ribuan
            let index = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index)
        case 5: //puluhan ribu
            let index = result.index(result.startIndex, offsetBy: 2)
            result.insert(".", at: index)
        case 6: //ratusan ribu
            let index = result.index(result.startIndex, offsetBy: 3)
            result.insert(".", at: index)
        case 7: //jutaan
            let index1 = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 5)
            result.insert(".", at: index2)
        case 8: //puluhan juta
            let index1 = result.index(result.startIndex, offsetBy: 2)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 6)
            result.insert(".", at: index2)
        case 9: //ratusan juta
            let index1 = result.index(result.startIndex, offsetBy: 3)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 7)
            result.insert(".", at: index2)
        case 10: //milyar
            let index1 = result.index(result.startIndex, offsetBy: 1)
            result.insert(".", at: index1)
            let index2 = result.index(result.startIndex, offsetBy: 5)
            result.insert(".", at: index2)
            let index3 = result.index(result.startIndex, offsetBy: 9)
            result.insert(".", at: index3)
        default:
            break
        }
        
        return result
    }
}

extension UIColor {

    @nonobjc class var nastyGreen: UIColor {
        return UIColor(red: 125.0 / 255.0, green: 178.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleOliveGreen: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 223.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var peacockBlue: UIColor {
        return UIColor(red: 0.0, green: 93.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var greyblue: UIColor {
        return UIColor(red: 103.0 / 255.0, green: 195.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var paleGrey: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 242.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var windowsBlue: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 126.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var dark: UIColor {
        return UIColor(red: 37.0 / 255.0, green: 54.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var black10: UIColor {
        return UIColor(white: 0.0, alpha: 0.1)
    }

    @nonobjc class var greenBlue: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 170.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var tiffanyBlue: UIColor {
        return UIColor(red: 115.0 / 255.0, green: 228.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkSlateBlue: UIColor {
        return UIColor(red: 36.0 / 255.0, green: 80.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var darkAqua: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var slateGrey: UIColor {
        return UIColor(red: 99.0 / 255.0, green: 101.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 136.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var coral: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 88.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 189.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkTwo: UIColor {
        return UIColor(white: 242.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var black: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }

    @nonobjc class var darkTwo: UIColor {
        return UIColor(red: 38.0 / 255.0, green: 44.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brownGreyTwo: UIColor {
        return UIColor(white: 129.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkThree: UIColor {
        return UIColor(white: 218.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkFour: UIColor {
        return UIColor(white: 196.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var white: UIColor {
        return UIColor(white: 246.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkFive: UIColor {
        return UIColor(white: 234.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var rustRed: UIColor {
        return UIColor(red: 177.0 / 255.0, green: 19.0 / 255.0, blue: 9.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var pastelRed: UIColor {
        return UIColor(red: 217.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var coolBlue: UIColor {
        return UIColor(red: 70.0 / 255.0, green: 147.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var tanGreen: UIColor {
        return UIColor(red: 156.0 / 255.0, green: 204.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var paleGreyTwo: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 252.0 / 255.0, blue: 1.0, alpha: 1.0)
    }

    @nonobjc class var darkThree: UIColor {
        return UIColor(red: 17.0 / 255.0, green: 22.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var whiteTwo: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkSix: UIColor {
        return UIColor(white: 224.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPinkSeven: UIColor {
        return UIColor(white: 240.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brownGreyThree: UIColor {
        return UIColor(red: 161.0 / 255.0, green: 161.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

extension UIButton {
    func getURL2(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data),
                httpURLResponse.url == url
                else { return }
            DispatchQueue.main.async() {
                self.setImage(image, for: .normal)
                self.imageView?.contentMode = .scaleAspectFit
                //self.image = image
            }
            }.resume()
    }
    
    public func downloadedFrom2(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        getURL2(url: url, contentMode: mode)
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImageView {
    func loadUrl(_ url: String) {
        self.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "Artboard 10@0.75x-8"))
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func getHeight() -> CGFloat {
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        return contentRect.height
    }
    
    func giveBorder(_ borderWidth: CGFloat, _ borderColor: UIColor) {
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func addShadow(_ offset: CGSize, _ color: UIColor, _ shadowRadius: CGFloat, _ opacity: Float) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
    }
}

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
    
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return self
        }
    }
    
    func contains(regex: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return false }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.count == 0 ? false : true
    }
    
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont?) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 11)], context: nil)
        return ceil(boundingBox.height)
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UITextField {
    func trim() -> String {
        return (text?.trim())!
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIScrollView {
    func scrollTo(y: CGFloat) {
        self.setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        self.contentSize = contentRect.size
    }
    
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension UIViewController {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}

extension BaseViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
