//
//  DBCtrl.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/2/22.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import SQLite

class DbManager {

// MARK: - 创建 数据库、表
    
    class public func dbSetup() -> Void {
        do {
            PrintLog(dbFullPath)
            let db = try Connection(dbFullPath)
            
            // 创建用户表
            var table = Table(userTB)
            try db.run(table.create(ifNotExists: true) { t in
                UserInfoModel.dbBind(t)
            })

            table = Table(AlbumBookTB)
            try db.run(table.create(ifNotExists: true) { t in
                AlbumBookModel.dbBind(t)
            })

            table = Table(SiteInfoTB)
            try db.run(table.create(ifNotExists: true) { t in
                SiteInfoModel.dbBind(t)
            })

            update(db)
            PrintLog("数据库版本：\(db.userVersion)")
            
        } catch {
            PrintLog("\(error)")
        }
    }
    
    class private func update(_ db: Connection) {
        switch db.userVersion {
        case 0:
            break
        default:
            break
        }
    }
}
