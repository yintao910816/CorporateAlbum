//
//  ServerDataModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/24.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

// MARK:
// MARK: 只返回请求结果 -- 状态
class ResponseStatusModel: HJModel{
 
    var data: String?
    var error: Int!
    var message: String = "操作失败"
        
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            [data       <-- "Data",
             error      <-- "Error",
             message    <-- "Message"]
    }
    
}

// MARK:
// MARK: 列表数据类型
class ResponseListModel: HJModel {

}

// MARK:
// MARK: 单一模型数据
class ResponseModel: HJModel {
   
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


