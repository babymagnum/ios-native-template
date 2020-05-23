//
//  JamKerjaTimModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct DaftarShift: Decodable {
    var status: Bool
    var messages = [String]()
    var data: DaftarShiftData?
}

struct DaftarShiftData: Decodable {
    var url: String?
}
