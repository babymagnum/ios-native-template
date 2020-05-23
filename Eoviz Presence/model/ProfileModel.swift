//
//  ProfileModel.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 22/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Profile: Decodable {
    var status: Bool
    var messages = [String]()
    var data: ProfileData?
}

struct ProfileData: Decodable {
    var emp_number: String?
    var emp_name: String?
    var emp_position: String?
    var emp_unit: String?
    var photo: String?
}
