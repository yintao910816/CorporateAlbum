//
//  CAApp.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/14.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAApkInfoModel: HJModel {
    var Id: String = ""
    /// 版本号
    var VersionCode: Int = 0
    /// 版本名称
    var VersionName: String = ""
    /// 下载地址
    var DownloadUrl: String = ""
    /// 更新描述
    var UpdateMessage: String = ""
    
    var IsInCheck: Bool = false
}
