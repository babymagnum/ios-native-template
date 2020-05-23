//
//  SuccessData.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 19/02/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import Foundation

struct Success: Decodable {
    var status: Bool
    var messages = [String]()
    var data: SuccessData?
}

struct SuccessData: Decodable {

}
