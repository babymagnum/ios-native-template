//
//  RiwayatIzinCutiModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 21/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct RiwayatIzinCutiItem: Decodable {
    var permission_id: String?
    var permission_number: String?
    var permission_status: Int?
    var permission_date_request: String?
    var permission_reason: String?
    var date: String?
}

struct RiwayatIzinCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: RiwayatIzinCutiData?
}

struct RiwayatIzinCutiData: Decodable {
    var total_page: Int
    var list = [RiwayatIzinCutiItem]()
}
