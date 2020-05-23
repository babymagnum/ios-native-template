//
//  Presensi.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 14/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Presensi: Decodable {
    var status: Bool
    var messages = [String]()
    var data: PresensiData?
}

struct PresensiData: Decodable {
    var date: String?
    var timezone_code: String?
    var shift_name: String?
    var shift_id: Int?
    var presence_shift_start: String?
    var presence_shift_end: String?
    var is_presence_in: Bool?
    var server_time: String?
    var presence_zone = [PresenseZone]()
    var zoom_maps: Int?
}

struct PresenseZone: Decodable {
    var preszone_id: Int?
    var preszone_latitude: String?
    var preszone_longitude: String?
    var preszone_radius: String?
}
