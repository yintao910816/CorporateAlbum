//
//  CAOrder.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAOrderInfoModel: HJModel {
    var Id: String = ""
    /// 站点域名
    var SiteName: String = ""
    /// 商务代表Id
    var OwnerId: String = ""
    /// 商务代表名称
    var OwnerName: String = ""
    /// 设计师Id
    var DesignerId: String = ""
    /// 设计师名称
    var DesignerName: String = ""
    /// 完成时间
    var FinishTime: String = ""
    /// 合同时间
    var CreateTime: String = ""
    /// 合同金额
    var Price: Double = 0.0
    /// 已付款
    var Paid: Double = 0.0
    /// 订购产品Id集
    var Products: String = ""
    /// 发票备注
    var InvoiceNote: String = ""
    /// 客户备注
    var CustomerNote: String = ""
    /// 企业名称
    var CompanyName: String = ""
    /// 合同状态描述
    var StatusTitle: String = ""
    /// 订单类型描述
    var ContractTypeTitle: String = ""
}
