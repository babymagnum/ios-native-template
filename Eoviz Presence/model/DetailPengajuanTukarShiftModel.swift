//
//  DetailPengajuanTukarShiftModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 24/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

// MARK: Detail Exchange Shift
struct DetailExchangeShift: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DetailExchangeShiftData?
}

struct DetailExchangeShiftData: Decodable {
    var exchange_number: String?
    var request_date: String?
    var exchange_status: Int?
    var requestor: DetailExchangeShiftDataRequestor?
    var subtituted: DetailExchangeShiftDataSubstituted?
    var is_processed: Bool?
    var information_status = [InformationStatusItem]()
    var cancel_button: Bool?
    var cancel_note: String?
}

struct DetailExchangeShiftDataRequestor: Decodable {
    var emp_name: String?
    var photo: String?
    var emp_unit: String?
    var shift_date: String?
    var reason: String?
}

struct DetailExchangeShiftDataSubstituted: Decodable {
    var emp_name: String?
    var photo: String?
    var emp_unit: String?
    var shift_date: String?
}

struct InformationStatusItem: Decodable {
    var emp_name: String?
    var exchange_status: String?
    var status: Int?
    var status_datetime: String?
}
