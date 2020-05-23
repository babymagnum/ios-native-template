//
//  Preference.swift
//  Angkasa Pura Solusi
//
//  Created by Arief Zainuri on 27/07/19.
//  Copyright © 2019 Gama Techno. All rights reserved.
//

import Foundation

class Preference {
    
    func saveBool(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func saveString(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getString(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    func saveInt(value: Int, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getInt(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
}
