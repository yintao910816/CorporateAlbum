//
//  Page.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class AlbumPageModel: HJModel {
    var Id: String!
    var Title: String!
    /** 所属画册ID */
    var BookId: String!
    /** 所属站点域名 */
    var SiteName: String!
    var Priority: String!
    var Hits: String!
    var Detail: String = ""
    var MoreLink: String!
    var Picture: String!
    /** 是否有阅读奖励 */
    var HasAward: Bool!
    /**  奖励优惠券号码  */
    var CouponNo: String = ""
}
