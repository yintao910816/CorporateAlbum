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
fileprivate let SummaryEx     = Expression<String>("Summary")
fileprivate let SiteNameEx     = Expression<String>("SiteName")
fileprivate let CompanyEx     = Expression<String>("Company")
fileprivate let AppLogoEx     = Expression<String>("AppLogo")
fileprivate let SiteLogoEx     = Expression<String>("SiteLogo")
fileprivate let PictureEx     = Expression<String>("Picture")
fileprivate let QRCodeEx     = Expression<String>("QRCode")
fileprivate let SiteUrlEx     = Expression<String>("SiteUrl")
fileprivate let AlbumUrlEx     = Expression<String>("AlbumUrl")
fileprivate let EnabledAwardEx     = Expression<Bool>("EnabledAward")
fileprivate let PageAwardEx     = Expression<Int>("PageAward")
fileprivate let PageCountEx     = Expression<Int>("PageCount")
fileprivate let IsFavoriteEx     = Expression<Bool>("IsFavorite")

class AlbumBookModel: HJModel {
    var Id: String = ""
    var Title: String = ""
    /**  排序优先级  */
    var Summary: String = ""
    /** 所属站点域名 */
    var SiteName: String = ""
    /** 所属企业名称 */
    var Company: String = ""
    /** 所属站点APP LOGO */
    var AppLogo: String = ""
    /** 所属站点LOGO */
    var SiteLogo: String = ""
    /** 图片路径 */
    var Picture: String = ""
    /** 二维码地址 */
    var QRCode: String = ""
    /** 所属站点网址 */
    var SiteUrl: String = ""
    /** 所属画册网址 */
    var AlbumUrl: String = ""
    /** 是否启用奖励 */
    var EnabledAward: Bool = false
    /** 每页奖励:（分） */
    var PageAward: Int = 0
    /** 总奖励页数 */
    var PageCount: Int = 0
    /** 用户已经获取奖励页数 */
    var ReadCount: Int = 0
    /** 是否收藏 */
    var IsFavorite: Bool = false

    class func insert(datas: [AlbumBookModel]) {
        DBQueue.share.insterOrUpdateQueue(models: datas, AlbumBookTB, AlbumBookModel.self)
    }
}

extension AlbumBookModel: DBOperation {
    
    static func dbBind(_ builder:TableBuilder) -> Void {
        builder.column(IdEx)
        builder.column(TitleEx)
        builder.column(SummaryEx)
        builder.column(SiteNameEx)
        builder.column(CompanyEx)
        builder.column(AppLogoEx)
        builder.column(SiteLogoEx)
        builder.column(PictureEx)
        builder.column(QRCodeEx)
        builder.column(SiteUrlEx)
        builder.column(AlbumUrlEx)
        builder.column(EnabledAwardEx)
        builder.column(PageAwardEx)
        builder.column(PageCountEx)
        builder.column(IsFavoriteEx)
    }
    
    func setters() ->[Setter] {
        return [IdEx             <- Id,
                TitleEx          <- Title,
                SummaryEx        <- Summary,
                SiteNameEx       <- SiteName,
                CompanyEx        <- Company,
                AppLogoEx        <- AppLogo,
                SiteLogoEx       <- SiteLogo,
                PictureEx        <- Picture,
                QRCodeEx         <- QRCode,
                SiteLogoEx       <- SiteLogo,
                PictureEx        <- Picture,
                QRCodeEx         <- QRCode,
                SiteUrlEx        <- SiteUrl,
                AlbumUrlEx       <- AlbumUrl,
                EnabledAwardEx   <- EnabledAward,
                PageAwardEx      <- PageAward,
                PageCountEx      <- PageCount,
                IsFavoriteEx     <- IsFavorite,
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
                model.Summary   = book[SummaryEx]
                model.SiteName   = book[SiteNameEx]
                model.Company   = book[CompanyEx]
                model.AppLogo   = book[AppLogoEx]
                model.SiteLogo   = book[SiteLogoEx]
                model.Picture   = book[PictureEx]
                model.QRCode   = book[QRCodeEx]
                model.SiteUrl   = book[SiteUrlEx]
                model.AlbumUrl   = book[AlbumUrlEx]
                model.EnabledAward   = book[EnabledAwardEx]
                model.PageAward   = book[PageAwardEx]
                model.PageCount   = book[PageCountEx]
                model.IsFavorite   = book[IsFavoriteEx]

                datas.append(model)
            }
            
            return datas
            
        } catch {
            PrintLog("查询数据失败")
        }
        
        return [AlbumBookModel]()
    }

}

//fileprivate let IdEx           = Expression<String>("Id")
//fileprivate let SiteNameEx        = Expression<String>("SiteName")
//fileprivate let SiteTitleEx     = Expression<String>("SiteTitle")
//fileprivate let CompanyEx         = Expression<String>("Company")
//fileprivate let SummaryEx    = Expression<String>("Summary")
//fileprivate let AddressEx    = Expression<String>("Address")
//fileprivate let PhoneEx      = Expression<String>("Phone")
//fileprivate let ContactorEx     = Expression<String>("Contactor")
//fileprivate let MobileEx    = Expression<String>("Mobile")
//fileprivate let CompanyUrlEx     = Expression<String>("CompanyUrl")
//fileprivate let SiteLogoEx      = Expression<String>("SiteLogo")
//fileprivate let AppLogoEx       = Expression<String>("AppLogo")
//fileprivate let QRCodeEx     = Expression<String>("QRCode")
//fileprivate let SiteUrlEx     = Expression<String>("SiteUrl")
//fileprivate let EnableAwardEx     = Expression<Bool>("EnableAward")
//fileprivate let IsFavoriteEx     = Expression<Bool>("IsFavorite")
//fileprivate let AwardPageCountEx     = Expression<Int>("AwardPageCount")
//fileprivate let ReadCountEx     = Expression<Int>("ReadCount")
//
///// 首页数据
//class AlbumBookModel: HJModel {
//    var Id: String = ""
//    // 所属站点域名
//    var SiteName: String = ""
//    /// 站点标题
//    var SiteTitle: String = ""
//    /// 所属公司名称
//    var Company: String = ""
//    /// 站点简介
//    var Summary: String = ""
//    /// 公司地址
//    var Address: String = ""
//    /// 公司电话
//    var Phone: String = ""
//    /// 联系人
//    var Contactor: String = ""
//    /// 联系人电话
//    var Mobile: String = ""
//    /// 官网地址
//    var CompanyUrl: String = ""
//    /// 站点LOGO
//    var SiteLogo: String = ""
//    var AppLogo: String = ""
//    /// 站点二维码
//    var QRCode: String = ""
//    /// 所属站点网址
//    var SiteUrl: String = ""
//    /// 是否启用奖励
//    var EnableAward: Bool = false
//    /// 是否收藏：1是0否
//    var IsFavorite: Bool = false
//    /// 站点奖励总页数
//    var AwardPageCount: Int = 0
//    /// 用户已经获取奖励页数
//    var ReadCount: Int = 0
//
//    class func insert(datas: [AlbumBookModel]) {
//        DBQueue.share.insterOrUpdateQueue(models: datas, AlbumBookTB, AlbumBookModel.self)
//    }
//}
//
//extension AlbumBookModel: DBOperation {
//
//    static func dbBind(_ builder:TableBuilder) -> Void {
//        builder.column(IdEx)
//        builder.column(SiteNameEx)
//        builder.column(SiteTitleEx)
//        builder.column(CompanyEx)
//        builder.column(SummaryEx)
//        builder.column(AddressEx)
//        builder.column(PhoneEx)
//        builder.column(ContactorEx)
//        builder.column(MobileEx)
//        builder.column(CompanyUrlEx)
//        builder.column(SiteLogoEx)
//        builder.column(AppLogoEx)
//        builder.column(QRCodeEx)
//        builder.column(SiteUrlEx)
//        builder.column(EnableAwardEx)
//        builder.column(IsFavoriteEx)
//        builder.column(AwardPageCountEx)
//        builder.column(ReadCountEx)
//
//    }
//
//    func setters() ->[Setter] {
//        return [IdEx               <- Id,
//                SiteNameEx         <- SiteName,
//                SiteTitleEx        <- SiteTitle,
//                CompanyEx          <- Company,
//                SummaryEx          <- Summary,
//                AddressEx          <- Address,
//                PhoneEx            <- Phone,
//                ContactorEx        <- Contactor,
//                MobileEx           <- Mobile,
//                CompanyUrlEx       <- CompanyUrl,
//                SiteLogoEx         <- SiteLogo,
//                AppLogoEx          <- AppLogo,
//                QRCodeEx           <- QRCode,
//                SiteUrlEx          <- SiteUrl,
//                EnableAwardEx      <- EnableAward,
//                IsFavoriteEx       <- IsFavorite,
//                AwardPageCountEx   <- AwardPageCount,
//                ReadCountEx        <- ReadCount
//        ]
//    }
//
//    static func selectedFilier() -> Expression<Bool>? {
//        return IdEx != ""
//    }
//
//    func insertFilier() -> Expression<Bool>? {
//        return IdEx == Id
//    }
//
//    static func mapModel(query: Table?) -> [Any] {
//
//        do {
//            guard let db = UserInfoModel.db else {
//                return [AlbumBookModel]()
//            }
//
//            guard let t = query else {
//                return [AlbumBookModel]()
//            }
//            /**
//             fileprivate let IdEx           = Expression<String>("Id")
//             fileprivate let SiteNameEx        = Expression<String>("SiteName")
//             fileprivate let SiteTitleEx     = Expression<String>("SiteTitle")
//             fileprivate let CompanyEx         = Expression<String>("Company")
//             fileprivate let SummaryEx    = Expression<String>("Summary")
//             fileprivate let AddressEx    = Expression<String>("Address")
//             fileprivate let PhoneEx      = Expression<String>("Phone")
//             fileprivate let ContactorEx     = Expression<String>("Contactor")
//             fileprivate let MobileEx    = Expression<String>("Mobile")
//             fileprivate let CompanyUrlEx     = Expression<String>("CompanyUrl")
//             fileprivate let SiteLogoEx      = Expression<String>("SiteLogo")
//             fileprivate let AppLogoEx       = Expression<String>("AppLogo")
//             fileprivate let QRCodeEx     = Expression<String>("QRCode")
//             fileprivate let SiteUrlEx     = Expression<String>("SiteUrl")
//             fileprivate let EnableAwardEx     = Expression<Bool>("EnableAward")
//             fileprivate let IsFavoriteEx     = Expression<Bool>("IsFavorite")
//             fileprivate let AwardPageCountEx     = Expression<Int>("AwardPageCount")
//             fileprivate let ReadCountEx     = Expression<Int>("ReadCount")
//             */
//            var datas = [AlbumBookModel]()
//            for book in try db.prepare(t) {
//                let model = AlbumBookModel();
//                model.Id        = book[IdEx]
//                model.SiteName   = book[SiteNameEx]
//                model.SiteTitle       = book[SiteTitleEx]
//                model.Company = book[CompanyEx]
//                model.Summary      = book[SummaryEx]
//                model.Address           = book[AddressEx]
//                model.Phone = book[PhoneEx]
//                model.Contactor       = book[ContactorEx]
//                model.Mobile         = book[MobileEx]
//                model.CompanyUrl   = book[CompanyUrlEx]
//                model.SiteLogo   = book[SiteLogoEx]
//                model.AppLogo   = book[AppLogoEx]
//                model.QRCode   = book[QRCodeEx]
//                model.SiteUrl   = book[SiteUrlEx]
//                model.EnableAward   = book[EnableAwardEx]
//                model.IsFavorite   = book[IsFavoriteEx]
//                model.AwardPageCount   = book[AwardPageCountEx]
//                model.ReadCount   = book[ReadCountEx]
//
//                datas.append(model)
//            }
//
//            return datas
//
//        } catch {
//            PrintLog("查询数据失败")
//        }
//
//        return [AlbumBookModel]()
//    }
//
//}
