//
//  InformationNetworking.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 01/08/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking: BaseNetworking {
    func login(username: String, password: String, completion: @escaping(_ error: String?, _ login: Login?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/login"
        let body: [String: String] = [
            "username": username,
            "password": password,
            "fcm": preference.getString(key: constant.FCM_TOKEN),
            "device_id": "\(UIDevice().identifierForVendor?.description ?? "")",
            "device_brand": "iPhone",
            "device_series": UIDevice().name
        ]
        
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func home(completion: @escaping(_ error: String?, _ beranda: Beranda?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/home"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func preparePresence(completion: @escaping(_ error: String?, _ presensi: Presensi?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/preparePresence"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func logout(completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/logout"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func profile(completion: @escaping(_ error: String?, _ profile: Profile?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/profile"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func updateProfile(data: Data, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/updateProfile"
        alamofirePostFile(data: data, keyParameter: "photo", fileName: "\(PublicFunction.getCurrentMillis()).png", fileType: "png", url: url, body: nil, completion: completion)
    }
    
    func presence(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/presence"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func presenceList(date: String, completion: @escaping(_ error: String?, _ daftarPresensi: DaftarPresensi?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/presenceList?date=\(date)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func changeLanguage(completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/changeLanguage"
        let body: [String: String] = [
            "emp_lang": preference.getString(key: constant.LANGUAGE)
        ]
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func changePassword(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/changePassword"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func getEmpShiftList(body: [String: String], completion: @escaping(_ error: String?, _ shiftList: ShiftList?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/getEmpShiftList"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func sendExchange(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/sendExchange"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func getExchangeShiftHistory(page: String, year: String, status: String, completion: @escaping(_ error: String?, _ riwayatTukarShift: RiwayatTukarShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchangeShiftHistory?year=\(year)&page=\(page)&exchange_status=\(status)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func getExchangeShift(shiftExchangeId: String, completion: @escaping(_ error: String?, _ exchangeShift: ExchangeShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchange?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func detailExchangeShift(shiftExchangeId: String, completion: @escaping(_ error: String?, _ detailExchangeShift: DetailExchangeShift?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/detailExchangeShift?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func cancelExchangeShift(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/cancelExchangeShift"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func leaveApprovalList(page: Int, completion: @escaping(_ error: String?, _ leaveApproval: LeaveApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveApprovalList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func exchangeShiftApprovalList(page: Int, completion: @escaping(_ error: String?, _ exchangeShiftApproval: ExchangeShiftApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/exchangeShiftApprovalList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func notificationList(page: Int, completion: @escaping(_ error: String?, _ notification: Notification?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/notificationList"
        let body: [String: String] = [
            "page": "\(page)"
        ]
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func updateNotificationRead(notificationId: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/updateNotificationRead"
        let body: [String: String] = [
            "notification_id": notificationId
        ]
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func detailExchangeShiftApproval(shiftExchangeId: String, completion: @escaping(_ error: String?, _ detailExchangeShiftApproval: DetailExchangeShiftApproval?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/detailExchangeShift?shift_exchange_id=\(shiftExchangeId)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func submitExchangeShiftApproval(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitExchangeShiftApproval"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func tipeCuti(completion: @escaping(_ error: String?, _ tipeCuti: TipeCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveType"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func jatahCuti(completion: @escaping(_ error: String?, _ jatahCuti: JatahCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveQuota"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func forgetPassword(email: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/forgetPassword"
        let body: [String: String] = [
            "email": email
        ]
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func submitCodeForgetPassword(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitVerificationCodeForgetPassword"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func submitNewPassword(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitNewPassword"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func newDevice(body: [String: String], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/newDevice"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func submitCuti(body: [String: Any], oldFileName: String?, data: Data?, fileName: String?, fileType: String?, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitLeave"
        
        if let _data = data, let _fileName = fileName, let _fileType = fileType {
            var newBody = body
            
            if let _oldFileName = oldFileName {
                newBody.updateValue(_oldFileName, forKey: "attachment_old_filename")
            }
            
            alamofirePostFile(data: _data, keyParameter: "attachment", fileName: _fileName, fileType: _fileType, url: url, body: newBody, completion: completion)
        } else {
            alamofirePostFormData(url: url, body: body, completion: completion)
        }
    }
    
    func historyCuti(page: Int, year: String, perstypeId: String, permissionStatus: String, completion: @escaping(_ error: String?, _ riwayatIzinCuti: RiwayatIzinCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveHistory?page=\(page)&year=\(year)&perstype_id=&permission_status=\(permissionStatus)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func detailCuti(permissionId: String, completion: @escaping(_ error: String?, _ detailIzinCuti: DetailIzinCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/leaveDetail"
        let body: [String: String] = [
            "permission_id": permissionId
        ]
        alamofireGet(url: url, body: body, completion: completion)
    }
    
    func cancelCuti(permissionId: String, statusNotes: String, completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/cancelLeave"
        let body: [String: String] = [
            "status_note": statusNotes,
            "permission_id": permissionId
        ]
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func getCuti(permissiondId: String, completion: @escaping(_ error: String?, _ getCuti: GetCuti?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/getLeave?permission_id=\(permissiondId)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func submitLeaveApproval(body: [String: Any], completion: @escaping(_ error: String?, _ success: Success?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/submitLeaveApproval"
        alamofirePostFormData(url: url, body: body, completion: completion)
    }
    
    func filterKaryawan(completion: @escaping(_ error: String?, _ filterKaryawan: FilterKaryawan?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/filterEmployeeSpv"
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func daftarShift(data: (dateStart: String, dateEnd: String, listKaryawan: [String]), completion: @escaping(_ error: String?, _ daftarShift: DaftarShift?, _ isExpired: Bool?) -> Void) {
        
        var url = "\(baseUrl())/v1/listShiftSpv?date_start=\(data.dateStart)&date_end=\(data.dateEnd)"
        data.listKaryawan.forEach { item in
            url += "&emp_id=\(item)"
        }
        alamofireGet(url: url, body: nil, completion: completion)
    }
    
    func prepareUpload(type: String, completion: @escaping(_ error: String?, _ prepareUpload: PrepareUpload?, _ isExpired: Bool?) -> Void) {
        let url = "\(baseUrl())/v1/prepareUpload?type=\(type)"
        alamofireGet(url: url, body: nil, completion: completion)
    }
}
