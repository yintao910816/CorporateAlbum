//
//  ShareUtils.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class ShareUtils {
    
    /**
     * 分享
     * thumbURL 图标-uiimage/图片地址
     * title - 标题
     * descr - 描述
     * webpageUrl - 分享的网页地址
     */
    class func presentShare(thumbURL: Any, title: String, descr: String, webpageUrl: String) {
        let messageObject = UMSocialMessageObject.init()
        let shareObject = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: thumbURL)!
        shareObject.webpageUrl = webpageUrl
        messageObject.shareObject = shareObject
        
        PrintLog("分享链接：\(String(describing: shareObject.webpageUrl))")
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),
                                                 NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue),
                                                 NSNumber(integerLiteral:UMSocialPlatformType.QQ.rawValue)])
        
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, info) in
            UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: NSObject().visibleViewController!, completion: { (data, error) in
                if error != nil {
                    PrintLog("分享失败：\(String(describing: error))")
                }else {
                    if let result = data as? UMSocialShareResponse {
                        PrintLog(result)
                    }else {
                        PrintLog("未知结果")
                    }
                }
            })
        }
    }
    
}
