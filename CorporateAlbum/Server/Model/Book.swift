//
//  Book.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import SQLite

fileprivate let IdEx           = Expression<String>("Id")
fileprivate let TitleEx        = Expression<String>("Title")
fileprivate let PriorityEx     = Expression<Int>("Priority")
fileprivate let HitsEx         = Expression<Int>("Hits")
fileprivate let PageAwardEx    = Expression<Int>("PageAward")
fileprivate let PageCountEx    = Expression<Int>("PageCount")
fileprivate let SummaryEx      = Expression<String>("Summary")
fileprivate let SiteNameEx     = Expression<String>("SiteName")
fileprivate let SiteTitleEx    = Expression<String>("SiteTitle")
fileprivate let SiteLogoEx     = Expression<String>("SiteLogo")
fileprivate let PictureEx      = Expression<String>("Picture")
fileprivate let QRCodeEx       = Expression<String>("QRCode")
fileprivate let HasAwardEx     = Expression<Int>("HasAward")

class AlbumBookModel: HJModel {
    var Id: String = ""
    var Title: String = ""
    /**  排序优先级  */
    var Priority: Int = 0
    /** 点击数 */
    var Hits: Int = 0
    /**  每页奖励:（分）*/
    var PageAward: Int = 0
    /** 页数 */
    var PageCount: Int = 0
    /** 画册简介 */
    var Summary: String = ""
    /** 所属站点域名 */
    var SiteName: String = ""
    /** 所属站点标题 */
    var SiteTitle: String = ""
    /**  所属站点LOGO  */
    var SiteLogo: String = ""
    /** 图片路径 */
    var Picture: String = ""
    /** 二维码地址 */
    var QRCode: String = ""
    /** 有阅读奖励的页数 */
    var HasAward: Int = 0
    
    class func insert(datas: [AlbumBookModel]) {
        DBQueue.share.insterOrUpdateQueue(models: datas, AlbumBookTB, AlbumBookModel.self)
    }
}

extension AlbumBookModel: DBOperation {
    
    static func dbBind(_ builder:TableBuilder) -> Void {
        builder.column(IdEx)
        builder.column(TitleEx)
        builder.column(PriorityEx)
        builder.column(HitsEx)
        builder.column(PageAwardEx)
        builder.column(PageCountEx)
        builder.column(SummaryEx)
        builder.column(SiteNameEx)
        builder.column(SiteTitleEx)
        builder.column(SiteLogoEx)
        builder.column(PictureEx)
        builder.column(QRCodeEx)
        builder.column(HasAwardEx)
    }
    
    func setters() ->[Setter] {
        return [IdEx             <- Id,
                TitleEx          <- Title,
                PriorityEx       <- Priority,
                HitsEx           <- Hits,
                PageAwardEx      <- PageAward,
                PageCountEx      <- PageCount,
                SummaryEx        <- Summary,
                SiteNameEx       <- SiteName,
                SiteTitleEx      <- SiteTitle,
                SiteLogoEx       <- SiteLogo,
                PictureEx        <- Picture,
                QRCodeEx   <- QRCode,
                HasAwardEx <- HasAward
        ]
    }
    
    static func selectedFilier() -> Expression<Bool>? {
        return IdEx != ""
    }
    
    func insertFilier() -> Expression<Bool>? {
        return IdEx == Id
    }
    
    static func mapModel(query: Table?) -> [Any] {
        
        do {
            guard let db = UserInfoModel.db else {
                return [AlbumBookModel]()
            }
            
            guard let t = query else {
                return [AlbumBookModel]()
            }
            
            var datas = [AlbumBookModel]()
            for book in try db.prepare(t) {
                let model = AlbumBookModel();
                model.Id        = book[IdEx]
                model.Title   = book[TitleEx]
                model.Priority       = book[PriorityEx]
                model.Hits = book[HitsEx]
                model.PageAward      = book[PageAwardEx]
                model.PageCount           = book[PageCountEx]
                model.Summary = book[SummaryEx]
                model.SiteName       = book[SiteNameEx]
                model.SiteTitle         = book[SiteTitleEx]
                model.SiteLogo   = book[SiteLogoEx]
                model.Picture   = book[PictureEx]
                model.QRCode   = book[QRCodeEx]
                model.HasAward   = book[HasAwardEx]
                
                datas.append(model)
            }
            
            return datas
            
        } catch {
            PrintLog("查询数据失败")
        }
        
        return [AlbumBookModel]()
    }

}
