//
//  NotifikasiModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 11/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Notification: Decodable {
    var status: Bool
    var messages = [String]()
    var data: NotificationData?
}

struct NotificationData: Decodable {
    var total_page: Int
    var is_unread: Int
    var notification = [NotificationItem]()
}

struct NotificationItem: Decodable {
    var notification_id: String?
    var notification_date: String?
    var notification_title: String?
    var notification_content: String?
    var notification_redirect: String?
    var notification_redirect_web: String?
    var notification_data_id: String?
    var notification_is_read: Int?
    var notification_is_mobile: Int?
}
