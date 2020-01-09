//
//  Bill.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class BillInfoModel: HJModel {
    var Id: String = ""
    var UserId: String = ""
    var UserName: String = ""
    /** 交易金额 */
    var Amount: String = ""
    /** 交易内容 */
    var Summary: String = ""
    /// 相关站点名称
    var SiteName: String = ""
    /** 相关内容预览图 */
    var Picture: String!
    /** 交易时间  */
    var CreateTime: String!
    /** 交易类型标题 */
    var CashTypeTitle: String!
}

class CASumIncomeModel: HJModel {
    /// 今日奖励收益
    var TodayIncome: Double = 0.0
    /// 本月奖励收益
    var MonthIncome: Double = 0.0
    /// 累计奖励收益
    var TotalIncome: Double = 0.0
    
    var todayIncomeText: NSAttributedString {
        get {
            let fundsText = "￥\(TodayIncome)元"
            let text = "今日收益\n\(fundsText)"
            return text.attributed(NSMakeRange(5, fundsText.count), .white, .systemFont(ofSize: 17))
        }
    }
    
    var monthIncomeText: NSAttributedString {
        get {
            let fundsText = "￥\(MonthIncome)元"
            let text = "本月收益\n\(fundsText)"
            return text.attributed(NSMakeRange(5, fundsText.count), .white, .systemFont(ofSize: 17))
        }
    }

    var totalIncomeText: NSAttributedString {
        get {
            let fundsText = "￥\(TotalIncome)元"
            let text = "累计收益\n\(fundsText)"
            return text.attributed(NSMakeRange(5, fundsText.count), .white, .systemFont(ofSize: 17))
        }
    }

}
