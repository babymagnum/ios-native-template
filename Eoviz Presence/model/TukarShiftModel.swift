//
//  TukarShift.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

// MARK: Exchange Shift
struct ExchangeShift: Decodable {
    var status: Bool
    var messages = [String]()
    var data: ExchangeShiftData?
}

struct ExchangeShiftData: Decodable {
    var shift_id: Int?
    var exchange_type: Int?
    var reason: String?
    var shift_date: String?
    var exchange_shift_date: String?
    var exchange_shift_id: Int?
    var exchange_emp_id: Int?
    var send_type: Int?
    var list = [ShiftListItem]()
}

// MARK: Shift Item
struct ShiftItem {
    var emp_id: Int
    var emp_name: String
    var shift_id: Int
    var shift_name: String
    var shift_start: String
    var shift_end: String
    var isSelected: Bool
}

struct ShiftListItem: Decodable {
    var emp_id: Int?
    var emp_name: String?
    var shift_id: Int?
    var shift_name: String?
    var shift_start: String?
    var shift_end: String?
}

struct ShiftList: Decodable {
    var status: Bool
    var messages = [String]()
    var data: ShiftListData?
}

struct ShiftListData: Decodable {
    var shift_id_requestor: Int
    var list = [ShiftListItem]()
}
