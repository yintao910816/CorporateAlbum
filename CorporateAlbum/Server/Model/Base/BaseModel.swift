//
//  ServerDataModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/24.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

enum RequestCode: Int {
    /// 请求成功
    case success = 0
    case badRequest
}

// MARK:
// MARK: 所有请求数据
class ResponseModel: HJModel{
    
    var error: Int!
    var message: String = "操作失败"
        
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            [error      <-- "Error",
             message    <-- "Message"]
    }
}

class DataModel<T>: ResponseModel {
    
    var Data: T?
    
}

/// 只返回请求是否成功
class RequestResultModel: ResponseModel {
    
    var data: String = ""
}

// MARK:
// MARK: 需要使用数据库
import SQLite

class DBBaseModel: HJModel {
    
    struct DBReserveKeys {
        static let reserveKey1Ex = Expression<String?>("reserveKey1")
        static let reserveKey2Ex = Expression<String?>("reserveKey2")
        static let reserveKey3Ex = Expression<String?>("reserveKey3")
        static let reserveKey4Ex = Expression<String?>("reserveKey4")
        static let reserveKey5Ex = Expression<Data?>("reserveKey5")
    }
    
    var reserveKey1: String?
    var reserveKey2: String?
    var reserveKey3: String?
    var reserveKey4: String?
    var reserveKey5: Data?
    
    public func inster() { }

}


