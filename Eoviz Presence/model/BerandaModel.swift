//
//  BerandaData.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct BerandaCarousel {
    var image: String
    var content: String
    var percentage: Double
    var percentageContent: String
}

struct Beranda: Decodable {
    var status: Bool
    var messages = [String]()
    var data: BerandaData?
}

struct BerandaData: Decodable {
    var emp_id: Int?
    var emp_name: String?
    var photo: String?
    var shift_name: String?
    var status_presence: String?
    var time_presence: String?
    var presence: BerandaPresence?
    var leave_quota: BerandaLeaveQuota?
}

struct BerandaPresence: Decodable {
    var target: Double
    var achievement: Double
}

struct BerandaLeaveQuota: Decodable {
    var quota: Double
    var used: Double
}
