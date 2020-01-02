//
//  UserDefault.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

let userDefault = UserDefaults.standard

extension UserDefaults{

    var appToken: String? {
        get {
            return string(forKey: kToken)
        }
        set {
            set(newValue, forKey: kToken)
            synchronize()
        }
    }
    
    var userType: UserType {
        get {
            return UserType(rawValue: integer(forKey: kUType))!
        }
        set {
            set(newValue.rawValue, forKey: kUType)
            synchronize()
        }
    }
    
    var isPopToRoot: Bool {
        get {
            return bool(forKey: kIsPopToRoot)
        }
        set {
            set(newValue, forKey: kIsPopToRoot)
            synchronize()
        }
    }
    
    var uid: String? {
        get {
            return string(forKey: kUid)
        }
        set {
            set(newValue, forKey: kUid)
            synchronize()
        }
    }
    
    var lanuchStatue: String {
        get {
            guard let statue = (object(forKey: kLoadLaunch) as? String) else {
                return ""
            }
            return statue
        }
        set {
            set(newValue, forKey: kLoadLaunch)
            synchronize()
        }
    }
}
