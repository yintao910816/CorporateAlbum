//
//  SRUserAPI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import Moya

enum CAH5Type: String {
    /// 用户协议
    case contract = "contract"
    /// 关于我们
    case aboutus = "aboutus"
    /// 服务协议
    case services = "services"
    /// 关于奖励
    case bonus = "bonus"
}

//MARK:
//MARK: 接口定义
enum API{
    /// app控制
    case appGet
    
    /**
     * 获取token，访问令牌,24小时内有效
     * sign：使用SHA1算法 对 时间戳+SECRET 进行摘要得到
     * timestamp: 时间戳
     *  key :  apple200
     *  secret :  YBKBEFPEASFYVD6DXCA77PQ8E7D6U6EX
     */
    case verify(sign: String, timestamp: String)
    
    /**
     * 注册
     * password：密码,使用SHA1加密
     * smscode： 短信验证码
     */
    case register(phone: String, nickName: String, password: String, smscode: String)
    
    /// 获取h5地址
    case document(type: CAH5Type)
    /**
     * 注册、找回密码 获取短息验证码
     */
    case smsSendCode(phone: String)
    
    /**
     * 登录
     */
    case login(phone: String, pass: String)
    
    /**
     * 重置密码
     */
    case setPassword(phone: String, password: String, smscode: String)
    
    /**
     * 获取用户个人信息
     */
    case getUserInfo
    
    /// 获取奖励账单统计 - 个人中心用到
    case sumIncome
    
    /**
     * 首页数据列表/搜索
     * limit：默认32
     * category 0:全部,1:推荐,2:收藏
     */
    case bookList(search: String, skip: Int, limit: Int, category: Int)
    
    /**
     * 获取画册信息
     */
    case getBookInfo(id: String)
    
    /**
     * 搜索所有画册收藏列表
     */
    case favoriteBook(search: String, skip: Int, limit: Int)
    
    /**
     * 企业数据列表 Site/List
     */
    case siteList(category: Int, search: String, skip: Int, limit: Int)
    /**
     * 搜索所有收藏的企业
     */
    case favoriteSite(search: String, skip: Int, limit: Int)
    
    /// 获取用户奖励账单列表
    case billListAward(search: String, skip: Int, limit: Int)
    
    /// 订单列表
    case orderList(skip: Int, limit: Int)
    /// 获取订单明细项表
    case orderListItems(orderId: String)
    /// 请求支付,返回支付宝请求信息
    case orderPay(orderId: String)
    
    /// 获取推广区域列表
    case listRegion(siteName: String)
    /// 添加站点推广区域
    case addRegion(siteName: String, regionCode: String, regionText: String)
    /// 删除推广站点区域
    case removeRegion(siteName: String, regionCode: String, regionText: String)
    /// 设置站点管理账号密码
    case setManagePassword(siteName: String, manageName: String, managePassword: String)
    /// 获取站点信息
    case getMySite(siteName: String)
    /// 开启/暂停我的站点
    case controllMySite(siteName: String)
    /// 启用禁用我的站点浏览奖励
    case controlMySiteAward(siteName: String)
    /// 重设我的站点浏览奖励
    case resetMySiteAward(siteName: String)
    /**
     * 修改手机号获取邮箱验证码
     */
    case setPhone(phone: String, smsCode: String)
    
    /**
     * 修改收款账号（支付宝）
     */
    case setAlipay(smsCode: String, account: String, accountName: String, cardNo: String, idCardImage: UIImage)
    
    /**
     * 修改手机号获取邮箱验证码
     */
    case setEmail(email: String, smsCode: String)
    
    /**
     * 修改昵称
     */
    case setNickName(nickName: String)
    
    /**
     * 修改头像
     */
    case setAvatar(image: UIImage)
    
    /// 更改用户所在地区
    case userSetRegion(regionCode: String, regionText: String)
    
    /**
     * 为当前用户发送手机验证码
     */
    case sendSmsCodeForMe
    
    /**
     * 为当前用户发送邮箱验证码
     */
    case setEmailCodeForMe
    
    /**
     * 收益明细
     */
    case bill(search: String, skip: Int, limit: Int)
    
    /**
     *我的通知
     */
    case notice(search: String, skip: Int, limit: Int)
    
    /**
     * 我的画册站点
     */
    case mySite(skip: Int, limit: Int)
    
    /// 获取站点日志
    case mySiteListLog(siteName: String, skip: Int, limit: Int)
    
    /**
     * 启用禁用我的站点浏览奖励
     */
    case siteEnableAward(siteName: String)
    
    /**
     * 上线/离线我的站点
     */
    case siteOnline(siteName: String)
    
    /**
     * 重设我的站点浏览奖励
     */
    case siteResetAward(siteName: String)
    
    /**
     *  获取画册所有页面列表
     *  bookId - 画册id
     */
    case albumPage(siteName: String, skip: Int, limit: Int)
    
    /// 获取画册所有页面列表
    case pageList(bookId: String, skip: Int, limit: Int)
    
    /// 获取企业详情信息
    case siteGet(siteName: String)
    
    /**
     * 阅读画册页面,执行奖励
     */
    case readAward(siteName: String, bookId: String, bookTitle: String, pageId: String, pageTitle: String)
    /**
     * 添加站点收藏
     */
    case siteFavorite(siteName: String)
    /**
     *  添加画册收藏
     */
    case addBook(bookId: String)
    
    /**
     * 设置通知为已读
     */
    case noticeRead(id: String)
    
    /// 生成空的订单信息（下单使用）
    case orderCreateNew
    /// 提交服务订单
    case orderSubmitNew(siteName: String, companyId: String, orderJson: String)
    /// 会员获取我的的公司名称列表
    case companyList
    
    /// 生成空的订单信息（充值和续费使用）
    case orderCreateRenew
    /// 提交续费服务订单（充值和续费使用）
    case orderSubmitRenew(siteName: String, orderJson: String)
    
    ///  获取提现资费信息和用户账号信息
    case withdraw
    ///  提取现金
    case withdrawSubmit(amount: Double)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .appGet:
            return "App/Get"
            
        case .verify(_, _):
            return "Token/Verify"
        case .register(_, _, _, _):
            return "User/Register"
        case .smsSendCode(_):
            return "Sms/SendCode"
        case .login(_, _):
            return "User/Login"
        case .document(_):
            return "Document/Get"
        case .setPassword(_, _, _):
            return "User/SetPassword"
        case .setAvatar(_):
            return "User/SetPhoto"
        case .userSetRegion(_):
            return "User/SetRegion"
        case .getUserInfo:
            return "User/Get"
        case .sumIncome:
            return "Bill/SumIncome"
        case .bookList(_):
            return "Book/List"
        case .getBookInfo(_):
            return "Book/Get"
        case .favoriteBook(_, _, _):
            return "Favorite/Book"
        case .siteList(_):
            return "Site/List"
        case .billListAward(_):
            return "Bill/ListAward"
        case .favoriteSite(_, _, _):
            return "Favorite/Site"
            
        case .setPhone(_, _):
            return "User/SetPhone"
        case .setAlipay(_):
            return "User/SetAliPay"
        case .setEmail(_, _):
            return "User/SetEmail"
        case .setNickName(_):
            return "User/SetName"
            
        case .sendSmsCodeForMe:
            return "Sms/SendCodeForMe"
        case .setEmailCodeForMe:
            return "Email/SendCodeForMe"
            
        case .bill(_, _, _):
            return "Bill"
        case .notice(_, _, _):
            return "Notice"
        case .mySite(_, _):
            return "MySite/List"
        case .mySiteListLog(_):
            return "MySite/ListLog"
        case .siteEnableAward(_):
            return "Site/EnableAward"
        case .siteOnline(_):
            return "Site/Online"
        case .siteResetAward(_):
            return "Site/ResetAward"
        case .listRegion(_):
            return "MySite/ListRegion"
        case .addRegion(_):
            return "MySite/AddRegion"
        case .removeRegion(_):
            return "MySite/RemoveRegion"
        case .setManagePassword(_):
            return "MySite/SetManagePassword"
        case .getMySite(_):
            return "MySite/Get"
        case .controllMySite(_):
            return "MySite/Online"
        case .controlMySiteAward(_):
            return "MySite/EnableAward"
        case .resetMySiteAward(_):
            return "MySite/ResetAward"
            
        case .orderList(_):
            return "Order/List"
        case .orderListItems(_):
            return "Order/ListItems"
        case .orderPay(_):
            return "Order/Pay"
            
        case .albumPage(_):
            return "Book/ListBySite"
        case .pageList(_):
            return "Page/List"
        case .siteGet(_):
            return "Site/Get"
            
        case .readAward(_):
            return "Page/Read"
        case .siteFavorite(_):
            return "Site/Favorite"
        case .addBook(_):
            return "Book/Favorite"
            
        case .noticeRead(_):
            return "Notice/Read"
            
        case .orderCreateNew:
            return "Order/CreateNew"
        case .orderSubmitNew(_):
            return "Order/SubmitNew"
        case .companyList:
            return "Order/CompanyList"
            
        case .orderCreateRenew:
            return "Order/CreateRenew"
        case .orderSubmitRenew(_):
            return "Order/SubmitRenew"
            
        case .withdraw:
            return "Withdraw/Account"
        case .withdrawSubmit(_):
            return "Withdraw/Submit"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
   
    var task: Task {
        switch self {
        case .setAvatar(let image):
            var datas = [MultipartFormData]()
            if let data = image.jpegData(compressionQuality: 0.5) {
                let imageName = String.init(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000)
                let d = MultipartFormData.init(provider: .data(data), name: "file", fileName: imageName, mimeType: "image/png")
                datas.append(d)
            }
            return .uploadCompositeMultipart(datas, urlParameters: parameters!)
        case .setAlipay(let data):
            var datas = [MultipartFormData]()
            if let imageData = data.idCardImage.jpegData(compressionQuality: 0.5) {
                let imageName = String.init(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000)
                let d = MultipartFormData.init(provider: .data(imageData), name: "file", fileName: imageName, mimeType: "image/png")
                datas.append(d)
            }
            return .uploadCompositeMultipart(datas, urlParameters: parameters!)

        default:
            if let _parameters = parameters {
                return .requestParameters(parameters: _parameters, encoding: URLEncoding.default)
            }
            
            return .requestPlain
        }
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return stubbedResponse("ttt") }

    var validate: Bool { return false }
    
    var headers: [String : String]? {
        return ["ApiToken": userDefault.appToken ?? "",
                "appVersion": Bundle.main.version,
                "appName": "ebooke_ios"]
    }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .appGet:
            params["appName"] = "ebooke_ios"

        case .getUserInfo,
             .sendSmsCodeForMe,
             .setEmailCodeForMe,
             .setAvatar(_):
            params["token"]  = userDefault.appToken ?? ""
        case .userSetRegion(let regionCode, let regionText):
            params["regionCode"] = regionCode
            params["regionText"] = regionText

        case .verify(let sign, let timestamp):
            params["key"]  = "ebooke_ios"
            params["sign"] = sign
            params["timestamp"]  = timestamp
        case .register(let phone, let nickName, let password, let smscode):
            params["token"]  = userDefault.appToken ?? ""
            params["phone"]  = phone
            params["nickName"] = nickName
            params["password"] = password.sha1()
            params["smscode"]  = smscode
        case .smsSendCode(let phone):
            params["token"]  = userDefault.appToken ?? ""
            params["mobile"]  = phone
        case .login(let phone, let pass):
            params["token"]  = userDefault.appToken ?? ""
            params["phone"]  = phone
            params["password"]  = pass.sha1()
        case .document(let type):
            params["name"]  = type.rawValue
        case .setPassword(let phone, let password, let smscode):
            params["token"]  = userDefault.appToken ?? ""
            params["phone"]  = phone
            params["password"] = password.sha1()
            params["smscode"]  = smscode
        case .bookList(let search, let skip, let limit, let category):
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
            params["category"]  = category
        case .getBookInfo(let id):
            params["id"]     = id
        case .favoriteBook(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .siteList(let category, let search, let skip, let limit):
            params["category"]   = category
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .billListAward(let search, let skip, let limit):
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .favoriteSite(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit

        case .setPhone(let phone, let smsCode):
            params["smsCode"] = smsCode
            params["phone"]  = phone
        case .setEmail(let email, let smsCode):
            params["token"]  = userDefault.appToken ?? ""
            params["email"] = email
            params["smscode"]  = smsCode
        case .setAlipay(let smsCode, let account, let accountName, let cardNo, _):
            params["smsCode"]  = smsCode
            params["account"]  = account
            params["accountName"]  = accountName
            params["cardNo"]  = cardNo.sha1()
            break
        case .setNickName(let nickName):
            params["nickName"] = nickName

        case .bill(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .notice(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .mySite(let skip, let limit):
            params["skip"]   = skip
            params["limit"]  = limit
        case .mySiteListLog(let siteName, let skip, let limit):
            params["siteName"]  = siteName
            params["skip"]   = skip
            params["limit"]  = limit
        case .siteEnableAward(let siteName):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"]   = siteName
        case .siteOnline(let siteName):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"]   = siteName
        case .siteResetAward(let siteName):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"]   = siteName
            
        case .listRegion(let siteName):
            params["siteName"]   = siteName
        case .addRegion(let siteName, let regionCode, let regionText):
            params["siteName"]   = siteName
            params["regionCode"]   = regionCode
            params["regionText"]   = regionText
        case .removeRegion(let siteName, let regionCode, let regionText):
            params["siteName"]   = siteName
            params["regionCode"]   = regionCode
            params["regionText"]   = regionText
        case .setManagePassword(let siteName, let manageName, let managePassword):
            params["siteName"]       = siteName
            params["manageName"]     = manageName
            params["managePassword"] = managePassword
        case .getMySite(let siteName):
            params["siteName"] = siteName
        case .controllMySite(let siteName):
            params["siteName"] = siteName
        case .controlMySiteAward(let siteName):
            params["siteName"] = siteName
        case .resetMySiteAward(let siteName):
            params["siteName"] = siteName

        case .albumPage(let siteName, let skip, let limit):
            params["siteName"] = siteName
            params["skip"]   = skip
            params["limit"]  = limit
        case .pageList(let bookId, let skip, let limit):
            params["bookId"] = bookId
            params["skip"]   = skip
            params["limit"]  = limit
        case .siteGet(let siteName):
            params["siteName"] = siteName

        case .readAward(let siteName, let bookId, let bookTitle, let pageId, let pageTitle):
            params["siteName"] = siteName
            params["bookId"] = bookId
            params["bookTitle"] = bookTitle
            params["pageId"] = pageId
            params["pageTitle"] = pageTitle
        case .siteFavorite(let siteName):
            params["siteName"]   = siteName
        case .addBook(let bookId):
            params["bookId"] = bookId
            
        case .noticeRead(let id):
            params["token"]  = userDefault.appToken ?? ""
            params["id"] = id
            
        case .orderList(let skip, let limit):
            params["skip"]   = skip
            params["limit"]  = limit
        case .orderListItems(let orderId):
            params["orderId"]  = orderId
        case .orderPay(let orderId):
            params["orderId"]  = orderId
        case .orderSubmitNew(let siteName, let companyId, let orderJson):
            params["siteName"]  = siteName
            params["companyId"] = companyId
            params["orderJson"] = orderJson
        
        case .orderSubmitRenew(let siteName, let orderJson):
            params["siteName"]  = siteName
            params["orderJson"] = orderJson

        case .withdrawSubmit(let amount):
            params["amount"] = amount
        default:
            break
        }
        return params
    }

}


func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

//MARK:
//MARK: API server
let CARProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                               RequestLoadingPlugin()])
