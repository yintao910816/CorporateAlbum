//
//  Bill.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class BillInfoModel: HJModel {
    var Id: String!
    var UserId: String!
    var UserName: String!
    /** 交易金额 */
    var Amount: String!
    /** 交易内容 */
    var Summary: String!
    /** 相关内容网址 */
    var Url: String!
    /** 相关内容预览图 */
    var Picture: String!
    /** 交易时间  */
    var CreateTime: String!
    /** 操作员 */
    var Creater: String!
    /** 交易类别 */
    var CashType: String!
    /** 交易类型标题 */
    var CashTypeTitle: String!
}
