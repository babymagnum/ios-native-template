//
//  FilterDaftarKaryawanModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct FilterKaryawanDataItem {
    var emp_id: Int
    var emp_name: String
    var isSelected: Bool
}

struct FilterKaryawan: Decodable {
    var status: Bool
    var messages = [String]()
    var data: FilterKaryawanData?
}

struct FilterKaryawanData: Decodable {
    var employee = [FilterKaryawanItem]()
}

struct FilterKaryawanItem: Decodable {
    var emp_id: Int?
    var emp_name: String?
}
