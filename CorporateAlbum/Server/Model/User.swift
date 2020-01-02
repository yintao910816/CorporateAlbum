//
//  User.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import SQLite

fileprivate let IdEx         = Expression<String>("Id")
fileprivate let RolesEx      = Expression<String>("Roles")
fileprivate let FundsEx      = Expression<String>("Funds")
fileprivate let MobileEx     = Expression<String>("Mobile")
fileprivate let NickNameEx   = Expression<String>("NickName")
fileprivate let AlipayEx     = Expression<String>("Alipay")
fileprivate let WeixinPayEx  = Expression<String>("WeixinPay")
fileprivate let IDCardEx     = Expression<String>("IDCard")
fileprivate let TrulyNameEx  = Expression<String>("TrulyName")
fileprivate let ExperienceEx = Expression<String>("Experience")
fileprivate let CreateTimeEx = Expression<String>("CreateTime")
fileprivate let VisitTimeEx  = Expression<String>("VisitTime")
fileprivate let LoginCountEx = Expression<Int>("LoginCount")
fileprivate let CompanyEx    = Expression<String>("Company")
fileprivate let SexEx        = Expression<Int>("Sex")
fileprivate let QQEx         = Expression<String>("QQ")
fileprivate let WeixinEx     = Expression<String>("Weixin")
fileprivate let EmailEx      = Expression<String>("Email")
fileprivate let UrlEx        = Expression<String>("Url")
fileprivate let RegionCodeEx = Expression<String>("RegionCode")
fileprivate let RegionTitleEx = Expression<String>("RegionTitle")
fileprivate let IndustryEx    = Expression<String>("Industry")
fileprivate let AddressEx     = Expression<String>("Address")
fileprivate let SummaryEx     = Expression<String>("Summary")
fileprivate let RoleTitleEx   = Expression<String>("RoleTitle")
fileprivate let SexTitleEx    = Expression<String>("SexTitle")
fileprivate let PhotoUrlEx    = Expression<String>("PhotoUrl")

class UserInfoModel: HJModel {
    var Id: String = ""
    var Roles: String = ""
    /** 资金余额 */
    var Funds: String = ""
    var Mobile: String = ""
    var NickName: String = ""
    /** 支付宝收款账号 */
    var Alipay: String = ""
    /** 微信开放平台ID  */
    var WeixinPay: String = ""
    /** 身份证号 */
    var IDCard: String = ""
    /** 真实姓名 */
    var TrulyName: String = ""
    /** 经验值 */
    var Experience: String = ""
    /** 注册时间 */
    var CreateTime: String = ""
    /** 最后访问时间 */
    var VisitTime: String = ""
    /** 登录次数 */
    var LoginCount: Int = 0
    /** 所在单位 */
    var Company: String = ""
    /** 性别 */
    var Sex: Int = 0
    var QQ: String = ""
    var Weixin: String = ""
    var Email: String = ""
    /** 个人主页 */
    var Url: String = ""
    /** 区域代码 */
    var RegionCode: String = ""
    /** 区域标题 */
    var RegionTitle: String = ""
    /** 职业 */
    var Industry: String = ""
    var Address: String = ""
    /** 备注 */
    var Summary: String = ""
    /** 角色说明 */
    var RoleTitle: String = ""
    /** 性别标题 */
    var SexTitle: String = ""
    /** 头像 */
    var PhotoUrl: String = ""
    
}

extension UserInfoModel {
    
    /**
     * 向数据库插入用户,存在则更新
     */
    public func insertUser() {
        DBQueue.share.insterOrUpdateQueue(model: self, userTB, UserInfoModel.self)
    }

    /**
     * 个人中心查询登录用户信息
     */
    static public func loginUser(result: @escaping ((UserInfoModel?) ->Void)) {
        if let uid = userDefault.uid {
            let filier = (IdEx == uid)
            DBQueue.share.selectQueue(filier, userTB, UserInfoModel.self) { table in
                if let model = mapModel(query: table).first as? UserInfoModel {
                    result(model)
                }
            }
        }else {
            result(nil)
        }
    }

}

extension UserInfoModel: DBOperation {
    static func selectedFilier() -> Expression<Bool>? {
        return nil
    }
    
    func insertFilier() -> Expression<Bool>? {
        return IdEx == Id
    }
    
    func setters() -> [Setter] {
        return [IdEx           <- Id,
                RolesEx        <- Roles,
                FundsEx        <- Funds,
                MobileEx       <- Mobile,
                NickNameEx     <- NickName,
                AlipayEx       <- Alipay,
                WeixinPayEx    <- WeixinPay,
                IDCardEx       <- IDCard,
                TrulyNameEx    <- TrulyName,
                ExperienceEx   <- Experience,
                CreateTimeEx   <- CreateTime,
                VisitTimeEx    <- VisitTime,
                LoginCountEx   <- LoginCount,
                CompanyEx      <- Company,
                SexEx          <- Sex,
                QQEx           <- QQ,
                WeixinEx       <- Weixin,
                EmailEx        <- Email,
                UrlEx          <- Url,
                RegionCodeEx   <- RegionCode,
                RegionTitleEx  <- RegionTitle,
                IndustryEx     <- Industry,
                AddressEx      <- Address,
                SummaryEx      <- Summary,
                RoleTitleEx    <- RoleTitle,
                SexTitleEx     <- SexTitle,
                PhotoUrlEx     <- PhotoUrl
        ]
    }
    
    func insertFilier() -> Expression<Bool> {
        return IdEx == Id
    }
        
    static func dbBind(_ builder: TableBuilder) {
        builder.column(IdEx)
        builder.column(RolesEx)
        builder.column(FundsEx)
        builder.column(MobileEx)
        builder.column(NickNameEx)
        builder.column(AlipayEx)
        builder.column(WeixinPayEx)
        builder.column(IDCardEx)
        builder.column(TrulyNameEx)
        builder.column(ExperienceEx)
        builder.column(CreateTimeEx)
        builder.column(VisitTimeEx)
        builder.column(LoginCountEx)
        builder.column(CompanyEx)
        builder.column(SexEx)
        builder.column(QQEx)
        builder.column(WeixinEx)
        builder.column(EmailEx)
        builder.column(UrlEx)
        builder.column(RegionCodeEx)
        builder.column(RegionTitleEx)
        builder.column(IndustryEx)
        builder.column(AddressEx)
        builder.column(SummaryEx)
        builder.column(RoleTitleEx)
        builder.column(SexTitleEx)
        builder.column(PhotoUrlEx)
    }
    
    static func mapModel(query: Table?) -> [Any] {

        do {
            guard let db = UserInfoModel.db else {
                return [UserInfoModel]()
            }
            
            guard let t = query else {
                return [UserInfoModel]()
            }
            
            var datas = [UserInfoModel]()
            for user in try db.prepare(t) {
                let model = UserInfoModel();
                model.Id           = user[IdEx]
                model.Roles        = user[RolesEx]
                model.Funds        = user[FundsEx]
                model.Mobile       = user[MobileEx]
                model.NickName     = user[NickNameEx]
                model.Alipay       = user[AlipayEx]
                model.WeixinPay    = user[WeixinPayEx]
                model.IDCard       = user[IDCardEx]
                model.TrulyName    = user[TrulyNameEx]
                model.Experience   = user[ExperienceEx]
                model.CreateTime   = user[CreateTimeEx]
                model.VisitTime    = user[VisitTimeEx]
                model.LoginCount   = user[LoginCountEx]
                model.Company      = user[CompanyEx]
                model.Sex          = user[SexEx]
                model.QQ           = user[QQEx]
                model.Weixin          = user[WeixinPayEx]
                model.Email           = user[EmailEx]
                model.Url             = user[UrlEx]
                model.RegionCode      = user[RegionCodeEx]
                model.RegionTitle     = user[RegionTitleEx]
                model.Industry        = user[IndustryEx]
                model.Address         = user[AddressEx]
                model.Summary         = user[SummaryEx]
                model.RoleTitle       = user[RoleTitleEx]
                model.SexTitle        = user[SexTitleEx]
                model.PhotoUrl        = user[PhotoUrlEx]

                datas.append(model)
            }
            
            return datas
            
        } catch {
            PrintLog("查询数据失败")
        }
        
        return [UserInfoModel]()
    }

}

class NoticeInfoModel: HJModel {
    var Id: String!
    var Title: String!
    /** 录入员 */
    var Creater: String = ""
    /** 录入时间 */
    var CreateTime: String = ""
    /** 预览图片 */
    var Picture: String = ""
    /** 内容简介 */
    var Summary: String = ""
    /** 链接地址 */
    var Link: String = ""
    /** 是否新通知 */
    var IsNewest: Bool = true
}
