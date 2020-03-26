//
//  CASite.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/3/26.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CASiteInfoModel: HJModel {
    var Id: String = ""
    /// 站点域名
    var SiteName: String = ""
    /// 站点标题
    var SiteTitle: String = ""
    /// 所属公司名称
    var Company: String = ""
    /// 站点简介
    var Summary: String = ""
    /// 公司地址
    var Address: String = ""
    /// 公司电话
    var Phone: String = ""
    /// 联系人
    var Contactor: String = ""
    /// 联系人电话
    var Mobile: String = ""
    /// 官网地址
    var CompanyUrl: String = ""
    /// 站点LOGO
    var SiteLogo: String = ""
    /// APP LOGO
    var AppLogo: String = ""
    /// 站点二维码
    var QRCode: String = ""
    /// 所属站点网址
    var SiteUrl: String = ""
    /// 是否启用奖励
    var EnableAward: Bool = false
    /// 是否收藏：1是0否
    var IsFavorite: Bool = false
    /// 站点奖励总页数
    var AwardPageCount: Int = 0
    /// 用户已经获取奖励页数
    var ReadCount: Int = 0
}
