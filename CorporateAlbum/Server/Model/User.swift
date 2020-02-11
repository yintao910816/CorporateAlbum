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
fileprivate let IsClientEx      = Expression<Bool>("IsClient")
fileprivate let FundsEx      = Expression<Double>("Funds")
fileprivate let MobileEx     = Expression<String>("Mobile")
fileprivate let NickNameEx     = Expression<String>("NickName")
fileprivate let IsRealNameEx     = Expression<Bool>("IsRealName")
fileprivate let AlipayEx     = Expression<String>("Alipay")
fileprivate let ExperienceEx     = Expression<Int>("Experience")
fileprivate let CreateTimeEx     = Expression<String>("CreateTime")
fileprivate let VisitTimeEx     = Expression<String>("VisitTime")
fileprivate let SessionIdEx     = Expression<String>("SessionId")
fileprivate let LoginCountEx     = Expression<Int>("LoginCount")
fileprivate let CompanyEx     = Expression<String>("Company")
fileprivate let SexEx     = Expression<String>("Sex")
fileprivate let QQEx     = Expression<String>("QQ")
fileprivate let EmailEx     = Expression<String>("Email")
fileprivate let UrlEx     = Expression<String>("Url")
fileprivate let RegionCodeEx     = Expression<String>("RegionCode")
fileprivate let RegionTitleEx     = Expression<String>("RegionTitle")
fileprivate let IndustryEx     = Expression<String>("Industry")
fileprivate let AddressEx     = Expression<String>("Address")
fileprivate let SummaryEx     = Expression<String>("Summary")
fileprivate let PhotoUrlEx     = Expression<String>("PhotoUrl")

class UserInfoModel: HJModel {
    var Id: String = ""
    /// 是否企业用户
    var IsClient: Bool = false
    /// 资金余额
    var Funds: Double = 0
    /// 手机号码
    var Mobile: String = ""
    /// 昵称
    var NickName: String = ""
    /// 是否实名认证
    var IsRealName: Bool = false
    /// 支付宝收款账号
    var Alipay: String = ""
    /// 经验值
    var Experience: Int = 0
    /// 注册时间
    var CreateTime: String = ""
    /// 最后访问时间
    var VisitTime: String = ""
    /// 最后访问会话Id
    var SessionId: String = ""
    /// 登录次数
    var LoginCount: Int = 0
    /// 所在单位
    var Company: String = ""
    /// 性别
    var Sex: String = ""
    /// QQ
    var QQ: String = ""
    /// 安全邮箱
    var Email: String = ""
    /// 个人主页
    var Url: String = ""
    /// 区域代码
    var RegionCode: String = ""
    /// 区域标题
    var RegionTitle: String = ""
    /// 职业
    var Industry: String = ""
    /// 住址
    var Address: String = ""
    /// 备注
    var Summary: String = ""
    /// 头像ID
    var PhotoUrl: String = ""
}

extension UserInfoModel {
    
    /**
     * 向数据库插入用户,存在则更新
     */
    public func insertUser(complement: (() ->())? = nil) {
        DBQueue.share.insterOrUpdateQueue(model: self, userTB, UserInfoModel.self) {
            complement?()
        }
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

    /// 修改昵称
    static public func update(nickName: String) {
        if let uid = userDefault.uid {
            let filier = (IdEx == uid)
            let setters = [NickNameEx <- nickName]
            DBQueue.share.updateQueue(filier, setters, userTB, UserInfoModel.self)
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
                IsClientEx        <- IsClient,
                FundsEx        <- Funds,
                MobileEx       <- Mobile,
                NickNameEx     <- NickName,
                IsRealNameEx       <- IsRealName,
                AlipayEx    <- Alipay,
                ExperienceEx       <- Experience,
                CreateTimeEx    <- CreateTime,
                VisitTimeEx   <- VisitTime,
                SessionIdEx   <- SessionId,
                LoginCountEx    <- LoginCount,
                CompanyEx   <- Company,
                SexEx      <- Sex,
                QQEx           <- QQ,
                EmailEx       <- Email,
                UrlEx          <- Url,
                RegionCodeEx   <- RegionCode,
                RegionTitleEx  <- RegionTitle,
                IndustryEx     <- Industry,
                AddressEx      <- Address,
                SummaryEx      <- Summary,
                PhotoUrlEx     <- PhotoUrl
        ]
    }
    
    func insertFilier() -> Expression<Bool> {
        return IdEx == Id
    }
        
    static func dbBind(_ builder: TableBuilder) {
        builder.column(IdEx)
        builder.column(IsClientEx)
        builder.column(FundsEx)
        builder.column(MobileEx)
        builder.column(NickNameEx)
        builder.column(IsRealNameEx)
        builder.column(AlipayEx)
        builder.column(ExperienceEx)
        builder.column(CreateTimeEx)
        builder.column(VisitTimeEx)
        builder.column(SessionIdEx)
        builder.column(LoginCountEx)
        builder.column(CompanyEx)
        builder.column(SexEx)
        builder.column(QQEx)
        builder.column(EmailEx)
        builder.column(UrlEx)
        builder.column(RegionCodeEx)
        builder.column(RegionTitleEx)
        builder.column(IndustryEx)
        builder.column(AddressEx)
        builder.column(SummaryEx)
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
                model.IsClient        = user[IsClientEx]
                model.Funds        = user[FundsEx]
                model.Mobile       = user[MobileEx]
                model.NickName     = user[NickNameEx]
                model.IsRealName    = user[IsRealNameEx]
                model.Alipay    = user[AlipayEx]
                model.Experience    = user[ExperienceEx]
                model.CreateTime    = user[CreateTimeEx]
                model.VisitTime    = user[VisitTimeEx]
                model.SessionId    = user[SessionIdEx]
                model.LoginCount    = user[LoginCountEx]
                model.Company    = user[CompanyEx]
                model.Sex    = user[SexEx]
                model.QQ    = user[QQEx]
                model.Email    = user[EmailEx]
                model.Url    = user[UrlEx]
                model.RegionCode    = user[RegionCodeEx]
                model.RegionTitle    = user[RegionTitleEx]
                model.Industry    = user[IndustryEx]
                model.Address    = user[AddressEx]
                model.Summary    = user[SummaryEx]
                model.PhotoUrl    = user[PhotoUrlEx]

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
