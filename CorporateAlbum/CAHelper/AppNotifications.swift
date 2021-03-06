//
//  AppNotifications.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

typealias NotificationName = Notification.Name

extension Notification.Name {
        
    public struct Album {
        /// 获取阅读奖励后，刷新首页画册界面
        public static let HomeAlbumRewardChanged = Notification.Name(rawValue: "org.album.notification.name.homeAlbumRewardChanged")
        /// 获取阅读奖励后，刷新站点画册界面
        public static let SiteAlbumRewardChanged = Notification.Name(rawValue: "org.album.notification.name.siteAlbumRewardChanged")
        /// 获取阅读奖励后，刷新企业界面
        public static let SiteRewardChanged      = Notification.Name(rawValue: "org.album.notification.name.siteRewardChanged")
    }
    
    public struct User {
        /// 修改完推广区域，请求新的推广区域
        public static let extensionRegionChanged = Notification.Name(rawValue: "org.album.notification.name.extensionRegionChanged")
        /// 推广区域更改，刷新界面
        public static let reloadExtensionRegionView = Notification.Name(rawValue: "org.album.notification.name.reloadExtensionRegionView")
        /// 站点信息改变，请求新的站点信息
        public static let siteInfoChanged = Notification.Name(rawValue: "org.album.notification.name.siteInfoChanged")
        /// 获取到新的站点信息处理界面刷新
        public static let reloadSiteInfoView = Notification.Name(rawValue: "org.album.notification.name.reloadSiteInfoView")
        /// 登录成功，获取用户信息
        public static let reloadUserInfo = Notification.Name(rawValue: "org.album.notification.name.reloadUserInfo")
        /// 修改用户信息成功后，刷新用户信息
        public static let userInfoEditSuccess = Notification.Name(rawValue: "org.album.notification.name.userInfoEditSuccess")
    }
    
    public struct Pay {
        /// 支付宝支付成功
        public static let alipaySuccess = Notification.Name(rawValue: "org.album.notification.name.alipaySuccess")
        /// 支付宝支付失败
        public static let alipayFailure = Notification.Name(rawValue: "org.album.notification.name.alipayFailure")
    }
}
