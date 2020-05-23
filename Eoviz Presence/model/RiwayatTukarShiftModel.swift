//
//  RiwayatTukarShift.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct RiwayatTukarShiftItem: Decodable {
    var exchange_id: String?
    var exchange_number: String?
    var exchange_status: Int?
    var exchange_request_date: String?
    var exchange_emp_name: String?
    var exchange_date_shift_name: String?
}

struct RiwayatTukarShift: Decodable {
    var status: Bool
    var messages = [String]()
    var data: RiwayatTukarShiftData?
}

struct RiwayatTukarShiftData: Decodable {
    var total_page: Int
    var list = [RiwayatTukarShiftItem]()
}
