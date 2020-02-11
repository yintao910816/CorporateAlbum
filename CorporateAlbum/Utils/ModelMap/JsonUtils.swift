//
//  JsonUtils.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/11.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import HandyJSON

class JsonUtils {
    
    static func json<T: HandyJSON>(with model: T) ->String? {
        return model.toJSONString()
    }
    
    static func json<T: HandyJSON>(with models: [T]) ->String? {
        var jsonString: String = "["
        for item in models {
            if let string = json(with: item) {
                if jsonString.count == 1 {
                    jsonString += string
                }else {
                    jsonString += ",\(string)"
                }
            }
        }
        
        if jsonString == "[" {
            return nil
        }
        
        return "\(jsonString)]"
    }
}
