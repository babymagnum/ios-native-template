//
//  DetailIzinCutiModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DetailIzinCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DetailIzinCutiData?
}

struct DetailIzinCutiData: Decodable {
    var permission_number: String?
    var permission_date_request: String?
    var permission_status: Int?
    var employee: DetailIzinCutiEmployee?
    var perstype_name: String?
    var permission_reason: String?
    var date_range: String?
    var dates = [DetailIzinCutiDatesItem]()
    var information_status = [DetailIzinCutiInformationStatusItem]()
    var is_processed: Bool?
    var cancel_button: Bool?
    var cancel_note: String?
    var attachment: DetailIzinCutiAttachment?
}

struct DetailIzinCutiAttachment: Decodable {
    var ori_name: String?
    var name: String?
    var url: String?
}

struct DetailIzinCutiEmployee: Decodable {
    var name: String?
    var photo: String?
    var unit: String?
}

struct DetailIzinCutiInformationStatusItem: Decodable {
    var emp_name: String?
    var permission_note: String?
    var status: Int?
    var status_datetime: String?
}

struct DetailIzinCutiDatesItem: Decodable {
    var date: String?
    var status: Int?
}
