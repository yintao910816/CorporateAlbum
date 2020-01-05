//
//  Page.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class AlbumPageModel: HJModel {
    var Id: String = ""
    /// 画册标题
    var Title: String = ""
    /// 画册简介
    var Summary: String = ""
    /// 所属站点域名
    var SiteName: String = ""
    /// 所属企业名称
    var Company: String = ""
    /// 所属站点APP LOGO
    var AppLogo: String = ""
    /// 所属站点LOGO
    var SiteLogo: String = ""
    /// 图片路径
    var Picture: String = ""
    /// 二维码地址
    var QRCode: String = ""
    /// 所属站点网址
    var SiteUrl: String = ""
    /// 所属画册网址
    var AlbumUrl: String = ""
    /// 是否启用奖励
    var EnabledAward: Bool = false
    /// 每页奖励:（分)
    var PageAward: Int = 0
    /// 总奖励页数
    var PageCount: Int = 0
    /// 用户已经获取奖励页数
    var ReadCount: Int = 0
    /// 是否收藏
    var IsFavorite: Bool = false
}
