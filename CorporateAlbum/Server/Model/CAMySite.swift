//
//  CAMySite.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/14.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAMySiteModel: HJModel {
    var Id: String = ""
    /// 站点域名
    var SiteName: String = ""
    /// 站点标题
    var SiteTitle: String = ""
    /// 所属企业名称
    var Company: String = ""
    /// 站点简介
    var Summary: String = ""
    /// 推广区域代码
    var RegionCode: String = ""
    /// 推广区域标题
    var RegionTitle: String = ""
    /// 创建时间
    var CreateDate: String = ""
    /// 失效时间
    var ExpireDate: String = ""
    /// 站点资金余额
    var Funds: Double = 0.00
    /// 累计奖励额
    var TotalAward: Double = 0.00
    /// 奖励画册页数
    var AwardPageCount: Int = 0
    /// 站点是否已失效或被禁用
    var IsDisabled: Bool = false
    /// 站点是否上线:前端可见
    var IsOnline: Bool = false
    /// 站点是否开启奖励
    var EnabledAward: Bool = false
    /// 站点LOGO
    var Logo: String = ""
    /// 站点二维码
    var QRCode: String = ""
    /// 所属站点网址
    var SiteUrl: String = ""
    /// 站点管理后台网址
    var ManageUrl: String = ""
    /// 站点管理后台用户名
    var ManageUserName: String = ""
    /// 站点管理后台密码
    var ManagePassword: String = ""

}
