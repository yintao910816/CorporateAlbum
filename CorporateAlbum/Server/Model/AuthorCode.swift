//
//  AuthorCode.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

class AuthorCodeModel: HJModel {
    
    var codeId: String!
    var iType: Int?
    var telphone: String!
    var uid: String?
    var addtime: String?
    var iUser: Bool?
    var oType: Int!
    
    // 用户输入的验证码
    var code: String?
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &codeId, name: "id")
    }

}

class BindPhoneModel: HJModel {
    
    var uid: String!
    var vipMoney: NSNumber!
    var ReceiveMoney: Int!
}
