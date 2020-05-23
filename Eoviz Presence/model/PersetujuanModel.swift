//
//  Persetujuan.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 16/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

// MARK: LeaveApproval
struct LeaveApproval: Decodable {
    var status: Bool
    var messages = [String]()
    var data: LeaveApprovalData?
}

struct LeaveApprovalData: Decodable {
    var total_page: Int
    var list = [LeaveApprovalItem]()
}

struct LeaveApprovalItem: Decodable {
    var leave_id: String?
    var leave_type: String?
    var emp_name: String?
    var photo: String?
    var request_date: String?
    var leave_date: String?
}

// MARK: ExchangeShiftApproval
struct ExchangeShiftApproval: Decodable {
    var status: Bool
    var messages = [String]()
    var data: ExchangeShiftApprovalData?
}

struct ExchangeShiftApprovalData: Decodable {
    var total_page: Int
    var exchange_shift_approval = [ExchangeShiftApprovalItem]()
}

struct ExchangeShiftApprovalItem: Decodable {
    var shift_exchange_id: String?
    var content: String?
    var photo: String?
    var request_date: String?
}
