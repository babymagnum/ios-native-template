//
//  IzinCuti.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 19/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct TanggalCutiItem {
    var date: String
    var isLast: Bool
    var isFirst: Bool
    var isOnlyOne: Bool
}

// MARK: Prepare Upload
struct PrepareUpload: Decodable {
    var status: Bool
    var messages = [String]()
    var data: PrepareUploadData?
}

struct PrepareUploadData: Decodable {
    var file_extension = [String]()
    var file_max_size: Int?
}

// MARK: Get Cuti for saved cuti
struct GetCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: GetCutiData?
}

struct GetCutiData: Decodable {
    var permission_id: String?
    var perstype_id: Int?
    var reason: String?
    var date_start: String?
    var date_end: String?
    var dates = [String]()
    var attachment: GetCutiAttachment?
}

struct GetCutiAttachment: Decodable {
    var ori_name: String?
    var name: String?
    var url: String?
}

// MARK: Tipe Cuti
struct TipeCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: TipeCutiData?
}

struct TipeCutiData: Decodable {
    var list = [TipeCutiItem]()
}

struct TipeCutiItem: Decodable {
    var perstype_id: Int?
    var perstype_name: String?
    var is_range: Int?
    var is_quota_reduce: Int?
    var is_allow_backdate: Int?
    var max_date: Int?
    var is_need_attachment: Int?
}

// MARK: Jatah Cuti
struct JatahCuti: Decodable {
    var status: Bool
    var messages = [String]()
    var data: JatahCutiData?
}

struct JatahCutiData: Decodable {
    var list = [JatahCutiItem]()
}

struct JatahCutiItem: Decodable {
    var start: String?
    var end: String?
    var expired: String?
    var quota: Int?
    var taken: Int?
    var available: Int?
}
