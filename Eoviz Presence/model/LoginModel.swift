//
//  Login.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 13/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Login: Decodable {
    var status: Bool
    var messages = [String]()
    var data: LoginData?
}

struct LoginData: Decodable {
    var emp_id: Int
    var emp_name: String
    var photo: String
    var token: String
    var emp_lang: String
}
