//
//  AppDelegate.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

@UIApplicationMain
class CAAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        application.statusBarStyle = .lightContent
        
        setupAppLogic()
        
        setupUM()
                
        window?.makeKeyAndVisible()
        
        PrintLog(NSTemporaryDirectory())
        return true
    }
    
}

extension CAAppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        PrintLog(url.absoluteString)
        
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                PrintLog("支付宝支付结果：\(String(describing: resultDic))")
                let status = resultDic?["resultStatus"] as! String
                
                let alipayResult = resultDic?["result"] as! String
                var resultDic: [String : Any]?
                do{
                    let dic = try JSONSerialization.jsonObject(with: alipayResult.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    resultDic = dic["alipay_trade_app_pay_response"] as? [String : Any]
                }
                catch{}

                if status == "9000"{
                    NotificationCenter.default.post(name: NotificationName.Pay.alipaySuccess, object: nil)
                }else{
                    var message = "支付失败"
                    if let code = resultDic?["code"] as? String {
                        message = "支付失败：\(code)"
                    }
                    NotificationCenter.default.post(name: NotificationName.Pay.alipayFailure, object: message)
                }
            })
            return true
        }
//        else if url.absoluteString.contains("tencent" + tencentAppid){
//            TencentOAuth.handleOpen(url)
//            let vc = ShowShareViewController()
//            return QQApiInterface.handleOpen(url, delegate: vc)
//        }else if url.scheme == weixinAppid{
//            return WXApi.handleOpen(url, delegate: self)
//        }
        
        return true
    }

//    func onReq(_ req: BaseReq!) {
//    }
    
//    func onResp(_ resp: BaseResp!) {
//        if resp.isKind(of: SendAuthResp.self) {
//            if resp.errCode == 0{
//                let obj = resp as! SendAuthResp
//                HttpClient.shareIntance.getWeixinOpenId(code: obj.code!)
//            }else{
//                HCShowError(info: "授权失败")
//            }
//        }else if resp.isKind(of: PayResp.self){
//            let obj = resp as! PayResp
//            if obj.errCode == 0{
//                //支付成功  发送通知
//                let not = Notification.init(name: NSNotification.Name.init(WEIXIN_SUCCESS), object: nil, userInfo: nil)
//                NotificationCenter.default.post(not)
//            }else{
//                //支付失败
//                let not = Notification.init(name: NSNotification.Name.init(PAY_FAIL), object: nil, userInfo: nil)
//                NotificationCenter.default.post(not)
//            }
//        }else if resp.isKind(of: SendMessageToWXResp.self){
//            if resp.errCode == 0{
//                //分享成功
//                showAlert(title: "分享成功", message: "")
//            }else{
//                showAlert(title: "分享不成功", message: "")
//            }
//        }
//    }
}

