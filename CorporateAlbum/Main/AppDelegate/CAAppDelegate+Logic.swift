//
//  CAAppDelegate+Logic.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/14.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

extension CAAppDelegate {
 
    public func setupAppLogic() {
        DbManager.dbSetup()

        _ = APIAssistance.requestAppInfo()
            .subscribe(onNext: {
                CACoreLogic.share.appInfo = $0
                CACoreLogic.share.reloadAppInfo.onNext(Void())
            }, onError: {
                NoticesCenter.alert(message: "获取app配置信息出错：\($0)")
            })
        
        _ = APIAssistance.requestToken()
            .subscribe(onNext: { _ in })
    }
}
