//
//  CAFunds.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/3/25.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

/// 获取提现相关信息
class CAWithdrawInfoModel: HJModel {
    /// 用户昵称
    var UserNickName: String = ""
    /// 支付宝账号
    var Alipay: String = ""
    /// 用户资金余额
    var UserFunds: Double = 0.0
    /// 提现最少金额
    var MinWithdwaw: Double = 0.0
    /// 提现服务续费率
    var Poundage: Double = 0.0
}
