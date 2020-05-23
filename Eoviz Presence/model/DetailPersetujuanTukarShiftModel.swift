//
//  DetailPersetujuanTukarShiftModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 25/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

// MARK: Detail Exchange Shift
struct DetailExchangeShiftApproval: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DetailExchangeShiftApprovalData?
}

struct DetailExchangeShiftApprovalData: Decodable {
    var exchange_number: String?
    var request_date: String?
    var exchange_status: Int?
    var requestor: DetailExchangeShiftDataRequestor?
    var subtituted: DetailExchangeShiftDataSubstituted?
    var information_status = [InformationStatusItem]()
    var cancel_button: Bool?
    var cancel_note: String?
}
