//
//  AppSetup.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

class AppSetup {

    static let instance = AppSetup()
    
    let secret: String = "YBKBEFPEASFYVD6DXCA77PQ8E7D6U6EX"
    
    /**
     版本号拼接到所有请求url
     不能超过1000
     */
    var urlVision: String{
        get{
            // 获取版本号
            let versionInfo = Bundle.main.infoDictionary
            let appVersion = versionInfo?["CFBundleShortVersionString"] as! String
            let resultString = appVersion.replacingOccurrences(of: ".", with: "")
            guard let resultInt = Int(resultString) else {
                return "100"
            }
            return resultInt >= 1000 ? "100" : resultString
        }
    }
    
}

import Moya

struct APIAssistance {
    
    /** 奖励提现h5 */
    static let cash = "http://aapi.dazongg.com/cash/withdraw"
    /** 续单/充值 */
    static let recharge = "http://order.dazongg.com/home/renew?site"
    /** 开通画册 */
    static let openAlbum = "http://order.dazongg.com/home/index"
    /** 使用帮助 */
    static let userHelp = "http://aapi.dazongg.com/help/index"
    
    /// 注册协议
    static let registerAggrement = "http://aapi.dazongg.net/document/get?name=contract"
    
    static let base     = "http://aapi.dazongg.net/"
    
    static public func baseURL(API: API) ->URL{
        /**
         获取域名
         */
        return URL(string: base)!
    }
    
    /**
     请求方式
     */
    static public func mothed(API: API) ->Moya.Method{
        switch API {
        case .bookList(_),
             .getBookInfo(_),
             .bill(_),
             .mySite(_),
             .albumPage(_),
             .favoriteBook(_):
            return .get
        default:
            return .post
        }
    }
}

extension APIAssistance {
    
    /**
     * 获取token
     */
    static func requestToken() {
        let timestamp = Date().milliStamp
        let signString = timestamp + AppSetup.instance.secret
        
        let _ = CARProvider.rx.request(.verify(sign: signString.sha1(), timestamp: timestamp))
            .mapJSON()
            .subscribe(onSuccess: { result in
                PrintLog(result)
                guard let ret = result as? [String: Any], let token = ret["Data"] as? String else{
                    NoticesCenter.alert(title: "提示", message: "令牌获取失败，请重新启动App")
                    return
                }
                userDefault.appToken = token
            }) { error in
                NoticesCenter.alert(title: "提示", message: "网络连接失败，请检查网络后重新打开app")
        }
    }

}
