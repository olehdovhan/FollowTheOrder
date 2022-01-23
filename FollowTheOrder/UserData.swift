//
//  UserData.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 22.01.2022.
//

import Foundation


class UserData {
    
    var level: Int? {
        get {
            let level = UserDefaults.standard.integer(forKey: "level")
            return level
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "level")
        }
    }
    
    static var shared: UserData = {
        let instance = UserData()
        return instance
    }()
    
    private init () {}
}

extension UserData: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
