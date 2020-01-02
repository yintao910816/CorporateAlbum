//
//  DBConfig.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/2/22.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

//MARK
//MARK: 数据基本配置
let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

let dbName = "cadataBase.sqlite3"

let dbFullPath = "\(dbPath)/\(dbName)"

//MARK
//MARK: 数据库表名
let userTB                = "CAUserTable"
// 首页画册
let AlbumBookTB           = "AlbumBookTB"
// 企业
let SiteInfoTB            = "CorporateInfoTB"
