//
//  CALogic.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class CACoreLogic {
    
    typealias blankBlock = ()->()

    public static let share = CACoreLogic()
    
    /// app 信息
    public var appInfo: CAApkInfoModel?
    
    public let reloadAppInfo = PublishSubject<Void>()
    
    public var isInCheck: Bool {
        get {
//            return appInfo == nil ? false : appInfo!.IsInCheck
            return false
        }
    }
}

extension CACoreLogic {
    
    /**
     * 弹出登录界面
     */
    class func pressentLoginVC() {
        let controller = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginControllerID")
        NSObject().visibleViewController?.present(controller, animated: true, completion: nil)
    }

}

extension CACoreLogic {
    
    /**
     * 清除cookie
     */
    class func clearCookie() {
        let url = URL(string: APIAssistance.base)!
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: url) {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    /**
     * 检查cookie是否存在，不存在跳登录界面
     */
    class func userLogin() {
        if isUserLogin() == false {
            pressentLoginVC()
        }
    }
    
    /**
     * 检查cookie是否存在，判断是否登录
     */
    class func isUserLogin() ->Bool {
        let url = URL(string: APIAssistance.base)!
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: url), cookies.count > 0 {
            PrintLog("已登录")
            return true
        }
        return false
    }

}

//MARK:
//MARK: -- 用户类型

enum UserType: Int {
    case tourist  = 0 // 游客类型
    case platform = 1 // 平台账号用户
}
