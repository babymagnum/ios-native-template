//
//  DetailPersetujuanIzinCutiModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 20/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct CutiTahunanItem {
    var date: String
    var isApprove: Bool
    var isFirst: Bool
    var isLast: Bool
    var isOnlyOne: Bool
}

struct DetailPersetujuanCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DetailPersetujuanCutiData?
}

struct DetailPersetujuanCutiData: Decodable {
    var permission_number: String?
    var permission_date_request: String?
    var permission_status: Int?
    var employee: DetailPersetujaunCutiEmployee?
    var perstype_name: String?
    var permission_reason: String?
    var date_range: String?
    var dates = [DetailPersetujuanCutiDates]()
    var information_status = [DetailPersetujuanCutiInformationStatus]()
    var is_processed: Bool?
    var cancel_button: Bool?
    var cancel_note: String?
}

struct DetailPersetujaunCutiEmployee: Decodable {
    var name: String?
    var photo: String?
    var unit: String?
}

struct DetailPersetujuanCutiDates: Decodable {
    var date: String?
    var status: Int?
}

struct DetailPersetujuanCutiInformationStatus: Decodable {
    var emp_name: String?
    var permission_note: String?
    var status: Int?
    var status_datetime: String?
}
