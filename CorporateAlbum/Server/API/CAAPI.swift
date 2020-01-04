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
    case getUserInfo()
    
    /**
     * 首页数据列表/搜索
     * limit：默认32
     */
    case book(search: String, skip: Int, limit: Int)
    
    /**
     * 获取画册信息
     */
    case getBookInfo(id: String)
    
    /**
     * 搜索所有画册收藏列表
     */
    case favoriteBook(search: String, skip: Int, limit: Int)
    
    /**
     * 企业数据列表
     */
    case site(search: String, skip: Int, limit: Int)
    /**
     * 搜索所有收藏的企业
     */
    case favoriteSite(search: String, skip: Int, limit: Int)
    
    /**
     * 修改手机号获取邮箱验证码
     */
    case setPhone(phone: String, emailCode: String)
    
    /**
     * 修改收款账号（支付宝）
     */
    case setAlipay(account: String, smsCode: String)
    
    /**
     * 修改手机号获取邮箱验证码
     */
    case setEmail(email: String, smsCode: String)
    
    /**
     * 修改昵称
     */
    case setNickName(nickName: String, smsCode: String)
    
    /**
     * 修改头像
     */
    case setAvatar(image: UIImage)
    
    /**
     * 为当前用户发送手机验证码
     */
    case sendSmsCodeForMe()
    
    /**
     * 为当前用户发送邮箱验证码
     */
    case setEmailCodeForMe()
    
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
    case albumPage(bookId: String)
    /**
     * 阅读画册页面,执行奖励
     */
    case readAward(siteName: String, siteTitle: String, siteLogo: String, bookId: String, bookTitle: String, pageId: String, pageTitle: String)
    /**
     * 添加站点收藏
     */
    case addSite(siteName: String, siteId: String)
    /**
     *  添加画册收藏
     */
    case addBook(siteName: String, bookId: String)
    
    /**
     * 设置通知为已读
     */
    case noticeRead(id: String)
    
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .verify(_, _):
            return "verify"
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
        case .getUserInfo():
            return "User/Get"
        case .book(_, _, _):
            return "Book"
        case .getBookInfo(_):
            return "Book/Get"
        case .favoriteBook(_, _, _):
            return "Favorite/Book"
        case .site(_, _, _):
            return "Site"
        case .favoriteSite(_, _, _):
            return "Favorite/Site"
            
        case .setPhone(_, _):
            return "User/SetPhone"
        case .setAlipay(_, _):
            return "User/SetPay"
        case .setEmail(_, _):
            return "User/SetEmail"
        case .setNickName(_, _):
            return "User/SetName"
            
        case .sendSmsCodeForMe():
            return "Sms/SendCodeForMe"
        case .setEmailCodeForMe():
            return "Email/SendCodeForMe"
            
        case .bill(_, _, _):
            return "Bill"
        case .notice(_, _, _):
            return "Notice"
        case .mySite(_, _):
            return "Site/My"
        case .siteEnableAward(_):
            return "Site/EnableAward"
        case .siteOnline(_):
            return "Site/Online"
        case .siteResetAward(_):
            return "Site/ResetAward"
            
        case .albumPage(_):
            return "Page"
        case .readAward(_, _, _, _, _, _, _):
            return "Read/Award"
        case .addSite(_, _):
            return "Favorite/AddSite"
        case .addBook(_, _):
            return "Favorite/AddBook"
            
        case .noticeRead(_):
            return "Notice/Read"
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
   
    var task: Task {
        switch self {
        case .setAvatar(let image):
            var datas = [MultipartFormData]()
            if let data = UIImageJPEGRepresentation(image, 0.5) {
                let imageName = String.init(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000)
                let d = MultipartFormData.init(provider: .data(data), name: "file", fileName: imageName, mimeType: "image/png")
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
    
    var headers: [String : String]? { return nil }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .getUserInfo(),
             .sendSmsCodeForMe(),
             .setEmailCodeForMe(),
             .setAvatar(_):
            params["token"]  = userDefault.appToken ?? ""
        case .verify(let sign, let timestamp):
            params["key"]  = "apple200"
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
        case .book(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .getBookInfo(let id):
            params["token"]  = userDefault.appToken ?? ""
            params["id"]     = id
        case .favoriteBook(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .site(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit
        case .favoriteSite(let search, let skip, let limit):
            params["token"]  = userDefault.appToken ?? ""
            params["search"] = search
            params["skip"]   = skip
            params["limit"]  = limit

        case .setPhone(let phone, let emailCode):
            params["emailcode"] = emailCode
            params["token"]  = userDefault.appToken ?? ""
            params["phone"]  = phone
        case .setEmail(let email, let smsCode):
            params["token"]  = userDefault.appToken ?? ""
            params["email"] = email
            params["smscode"]  = smsCode
        case .setAlipay(let account, let smsCode):
            params["token"]  = userDefault.appToken ?? ""
            params["account"] = account
            params["smscode"]  = smsCode
            break
        case .setNickName(let nickName, let smsCode):
            params["token"]  = userDefault.appToken ?? ""
            params["nickName"] = nickName
            params["smscode"]  = smsCode
            break
            
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
            params["token"]  = userDefault.appToken ?? ""
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
            
        case .albumPage(let bookId):
            params["token"]  = userDefault.appToken ?? ""
            params["bookId"] = bookId
        case .readAward(let siteName, let siteTitle, let siteLogo, let bookId, let bookTitle, let pageId, let pageTitle):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"] = siteName
            params["siteTitle"] = siteTitle
            params["siteLogo"] = siteLogo
            params["bookTitle"] = bookTitle
            params["bookId"] = bookId
            params["pageId"] = pageId
            params["pageTitle"] = pageTitle
            params["bookId"] = bookId
        case .addSite(let siteName, let siteId):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"] = siteName
            params["siteId"] = siteId
        case .addBook(let siteName, let bookId):
            params["token"]  = userDefault.appToken ?? ""
            params["siteName"] = siteName
            params["bookId"] = bookId
            
        case .noticeRead(let id):
            params["token"]  = userDefault.appToken ?? ""
            params["id"] = id
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
