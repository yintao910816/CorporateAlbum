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
    /** 关键词 */
    var Keywords: String = ""
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
    /** 创建时间 */
    var CreateDate: String = ""
    /** 失效时间 */
    var ExpireDate: String = ""
    /** 站点资金余额 */
    var Funds: String = ""
    /** 站点启用状态 0 上线 1 离线 2 禁用 */
    var SiteState: Int = 0
    /** 站点奖励状态 1 启用 0 禁用 */
    var AwardState: Int = 0
    /** 站点奖励总页数 */
    var AwardTotal: String = ""
    /** 站点启用状态说明 */
    var SiteStateTitle: String = ""
    /** 站点奖励状态说明 */
    var AwardStateTitle: String = ""
    /** 站点LOGO */
    var Logo: String = ""
    /** 站点二维码 */
    var QRCode: String = ""
    /** 管理后台地址 */
    var ControlUrl: String = ""
    /** 有阅读奖励的页数 */
    var HasAward: Int = 0
    
    var siteStateText: String {
        get {
            return ["离线站点", "上线站点", "已禁用"][SiteState]!
        }
    }
    
    var awardStateText: String {
        get {
            return AwardState == 0 ?  "启用奖励" : "禁用奖励"
        }
    }
    
    class func insert(datas: [SiteInfoModel]) {
        DBQueue.share.insterOrUpdateQueue(models: datas, SiteInfoTB, SiteInfoModel.self)
    }
}


import SQLite

fileprivate let IdEx              = Expression<String>("Id")
fileprivate let SiteNameEx        = Expression<String>("SiteName")
fileprivate let SiteTitleEx       = Expression<String>("SiteTitle")
fileprivate let CompanyEx         = Expression<String>("Company")
fileprivate let KeywordsEx        = Expression<String>("Keywords")
fileprivate let SummaryEx         = Expression<String>("Summary")
fileprivate let AddressEx         = Expression<String>("Address")
fileprivate let PhoneEx           = Expression<String>("Phone")
fileprivate let ContactorEx       = Expression<String>("Contactor")
fileprivate let MobileEx          = Expression<String>("Mobile")
fileprivate let CompanyUrlEx      = Expression<String>("CompanyUrl")
fileprivate let CreateDateEx      = Expression<String>("CreateDate")
fileprivate let ExpireDateEx      = Expression<String>("ExpireDate")
fileprivate let FundsEx           = Expression<String>("Funds")
fileprivate let SiteStateEx       = Expression<Int>("SiteState")
fileprivate let AwardStateEx      = Expression<Int>("AwardState")
fileprivate let AwardTotalEx      = Expression<String>("AwardTotal")
fileprivate let SiteStateTitleEx  = Expression<String>("SiteStateTitle")
fileprivate let AwardStateTitleEx = Expression<String>("AwardStateTitle")
fileprivate let LogoEx            = Expression<String>("Logo")
fileprivate let QRCodeEx          = Expression<String>("QRCode")
fileprivate let ControlUrlEx      = Expression<String>("ControlUrl")
fileprivate let HasAwardEx        = Expression<Int>("HasAward")

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
        builder.column(KeywordsEx)
        builder.column(SummaryEx)
        builder.column(AddressEx)
        builder.column(PhoneEx)
        builder.column(ContactorEx)
        builder.column(MobileEx)
        builder.column(CompanyUrlEx)
        builder.column(CreateDateEx)
        builder.column(ExpireDateEx)
        builder.column(FundsEx)
        builder.column(SiteStateEx)
        builder.column(AwardStateEx)
        builder.column(AwardTotalEx)
        builder.column(SiteStateTitleEx)
        builder.column(AwardStateTitleEx)
        builder.column(LogoEx)
        builder.column(QRCodeEx)
        builder.column(ControlUrlEx)
        builder.column(HasAwardEx)
    }
    
    func setters() ->[Setter] {
        return [IdEx               <- Id,
                SiteNameEx         <- SiteName,
                SiteTitleEx        <- SiteTitle,
                CompanyEx          <- Company,
                KeywordsEx         <- Keywords,
                SummaryEx          <- Summary,
                AddressEx          <- Address,
                PhoneEx            <- Phone,
                ContactorEx        <- Contactor,
                MobileEx           <- Mobile,
                CompanyUrlEx       <- CompanyUrl,
                CreateDateEx       <- CreateDate,
                ExpireDateEx       <- ExpireDate,
                FundsEx            <- Funds,
                SiteStateEx        <- SiteState,
                AwardStateEx       <- AwardState,
                AwardTotalEx       <- AwardTotal,
                SiteStateTitleEx   <- SiteStateTitle,
                AwardStateTitleEx  <- AwardStateTitle,
                LogoEx             <- Logo,
                QRCodeEx           <- QRCode,
                ControlUrlEx       <- ControlUrl,
                HasAwardEx         <- HasAward
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
                model.Keywords          = site[KeywordsEx]
                model.Summary           = site[SummaryEx]
                model.Address           = site[AddressEx]
                model.Phone             = site[PhoneEx]
                model.Contactor         = site[ContactorEx]
                model.Mobile            = site[MobileEx]
                model.CompanyUrl        = site[CompanyUrlEx]
                model.CreateDate        = site[CreateDateEx]
                model.ExpireDate        = site[ExpireDateEx]
                model.Funds             = site[FundsEx]
                model.SiteState         = site[SiteStateEx]
                model.AwardState        = site[AwardStateEx]
                model.AwardTotal        = site[AwardTotalEx]
                model.SiteStateTitle    = site[SiteStateTitleEx]
                model.AwardStateTitle   = site[AwardStateTitleEx]
                model.Logo            = site[LogoEx]
                model.QRCode          = site[QRCodeEx]
                model.ControlUrl      = site[ControlUrlEx]
                model.HasAward        = site[HasAwardEx]

                datas.append(model)
            }
            
            return datas
            
        } catch {
            PrintLog("查询数据失败")
        }
        
        return [SiteInfoModel]()
    }

}

