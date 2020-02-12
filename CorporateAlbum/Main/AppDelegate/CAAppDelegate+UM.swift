//
//  CAAppDelegate+UM.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

extension CAAppDelegate {
    
    public func setupUM() {
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey(um_appKey, channel: "App Store")
        
        UMSocialManager.default()?.openLog(true)
        UMSocialManager.default()?.setPlaform(.wechatSession,
                                              appKey: wx_appKey,
                                              appSecret: wx_secret,
                                              redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default()?.setPlaform(.wechatTimeLine,
                                              appKey: wx_appKey,
                                              appSecret: wx_secret,
                                              redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default()?.setPlaform(.QQ,
                                              appKey: qq_appID,
                                              appSecret: qq_appKey,
                                              redirectURL: "http://mobile.umeng.com/social")
    }
}
