//
//  DaftarPresensi.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DaftarPresensiItem: Decodable {
    var presence_date: String?
    var prestype_name: String?
    var prestype_bg_color: String?
    var presence_shift_start: String?
    var presence_shift_end: String?
    var presence_in: String?
    var presence_out: String?
    var presence_shift_name: String?
}

struct DaftarPresensi: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DaftarPresensiData?
}

struct DaftarPresensiData: Decodable {
    var list = [DaftarPresensiItem]()
}
