//
//  Corporate.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class SiteInfoModel: HJModel {
    var Id: String = ""
    /** 站点域名  */
    var SiteName: String = ""
    /** 站点标题 */
    var SiteTitle: String = ""
    /** 所属企业名称 */
    var Company: String = ""
    /** 站点简介 */
    var Summary: String = ""
    /** 公司地址 */
    var Address: String = ""
    /** 公司电话 */
    var Phone: String = ""
    /** 联系人 */
    var Contactor: String = ""
    /** 联系人电话 */
    var Mobile: String = ""
    /** 官网地址 */
    var CompanyUrl: String = ""
    /** 站点LOGO */
    var SiteLogo: String = ""
    /** APP LOGO */
    var AppLogo: String = ""
    /** 站点二维码 */
    var QRCode: String = ""
    /** 所属站点网址 */
    var SiteUrl: String = ""
    /// 是否启用奖励
    var EnableAward: Bool = false
    /// 是否收藏：1是0否
    var IsFavorite: Bool = false
    /// 站点奖励总页数
    var AwardPageCount: Int = 0
    /// 站点奖励总页数
    var ReadCount: Int = 0
    
//    var siteStateText: String {
//        get {
//            return ["离线站点", "上线站点", "已禁用"][SiteState]
//        }
//    }
//
//    var awardStateText: String {
//        get {
//            return AwardState == 0 ?  "启用奖励" : "禁用奖励"
//        }
//    }
    
    class func insert(datas: [SiteInfoModel]) {
        DBQueue.share.insterOrUpdateQueue(models: datas, SiteInfoTB, SiteInfoModel.self)
    }
}


import SQLite

fileprivate let IdEx              = Expression<String>("Id")
fileprivate let SiteNameEx        = Expression<String>("SiteName")
fileprivate let SiteTitleEx       = Expression<String>("SiteTitle")
fileprivate let CompanyEx         = Expression<String>("Company")
fileprivate let SummaryEx         = Expression<String>("Summary")
fileprivate let AddressEx         = Expression<String>("Address")
fileprivate let PhoneEx           = Expression<String>("Phone")
fileprivate let ContactorEx       = Expression<String>("Contactor")
fileprivate let MobileEx          = Expression<String>("Mobile")
fileprivate let CompanyUrlEx      = Expression<String>("CompanyUrl")
fileprivate let SiteLogoEx        = Expression<String>("SiteLogo")
fileprivate let AppLogoEx         = Expression<String>("AppLogo")
fileprivate let QRCodeEx          = Expression<String>("QRCode")
fileprivate let SiteUrlEx         = Expression<String>("SiteUrl")
fileprivate let EnableAwardEx     = Expression<Bool>("EnableAward")
fileprivate let IsFavoriteEx      = Expression<Bool>("IsFavorite")
fileprivate let AwardPageCountEx  = Expression<Int>("AwardPageCount")
fileprivate let ReadCountEx       = Expression<Int>("ReadCount")

extension SiteInfoModel: DBOperation {
    
    static func selectedFilier() -> Expression<Bool>? {
        return IdEx != ""
    }
    
    func insertFilier() -> Expression<Bool>? {
        return IdEx == Id
    }
    
    static func dbBind(_ builder:TableBuilder) -> Void {
        builder.column(IdEx)
        builder.column(SiteNameEx)
        builder.column(SiteTitleEx)
        builder.column(CompanyEx)
        builder.column(SummaryEx)
        builder.column(AddressEx)
        builder.column(PhoneEx)
        builder.column(ContactorEx)
        builder.column(MobileEx)
        builder.column(CompanyUrlEx)
        builder.column(SiteLogoEx)
        builder.column(AppLogoEx)
        builder.column(QRCodeEx)
        builder.column(SiteUrlEx)
        builder.column(EnableAwardEx)
        builder.column(IsFavoriteEx)
        builder.column(AwardPageCountEx)
        builder.column(ReadCountEx)
    }
    
    func setters() ->[Setter] {
        return [IdEx               <- Id,
                SiteNameEx         <- SiteName,
                SiteTitleEx        <- SiteTitle,
                CompanyEx          <- Company,
                SummaryEx          <- Summary,
                AddressEx          <- Address,
                PhoneEx            <- Phone,
                ContactorEx        <- Contactor,
                MobileEx           <- Mobile,
                CompanyUrlEx       <- CompanyUrl,
                SiteLogoEx         <- SiteLogo,
                AppLogoEx          <- AppLogo,
                QRCodeEx           <- QRCode,
                SiteUrlEx          <- SiteUrl,
                EnableAwardEx      <- EnableAward,
                IsFavoriteEx       <- IsFavorite,
                AwardPageCountEx   <- AwardPageCount,
                ReadCountEx        <- ReadCount
        ]
    }
    
    static func mapModel(query: Table?) -> [Any] {

        do {
            guard let db = SiteInfoModel.db else {
                return [SiteInfoModel]()
            }
            
            guard let t = query else {
                return [SiteInfoModel]()
            }
            
            var datas = [SiteInfoModel]()
            for site in try db.prepare(t) {
                let model = SiteInfoModel();
                model.Id        = site[IdEx]
                model.SiteName          = site[SiteNameEx]
                model.SiteTitle         = site[SiteTitleEx]
                model.Company           = site[CompanyEx]
                model.Summary           = site[SummaryEx]
                model.Address           = site[AddressEx]
                model.Phone             = site[PhoneEx]
                model.Contactor         = site[ContactorEx]
                model.Mobile            = site[MobileEx]
                model.CompanyUrl        = site[CompanyUrlEx]
                model.SiteLogo          = site[SiteLogoEx]
                model.AppLogo           = site[AppLogoEx]
                model.QRCode            = site[QRCodeEx]
                model.SiteUrl           = site[SiteUrlEx]
                model.EnableAward       = site[EnableAwardEx]
                model.IsFavorite        = site[IsFavoriteEx]
                model.AwardPageCount    = site[AwardPageCountEx]
                model.ReadCount         = site[ReadCountEx]

                datas.append(model)
            }
            
            return datas
            
        } catch {
            PrintLog("查询数据失败")
        }
        
        return [SiteInfoModel]()
    }

}

