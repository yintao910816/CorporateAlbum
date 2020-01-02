//
//  APIServer.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/24.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import Result

struct MoyaPlugins {
    
    static let MyNetworkActivityPlugin = NetworkActivityPlugin { (change, _) -> () in
        switch(change){
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
//    static let requestTimeoutClosure = {(endpoint: Endpoint<API>, done: @escaping MoyaProvider<API>.RequestResultClosure) in
//        guard var request = endpoint.urlRequest else { return }
//
//        request.timeoutInterval = 30    //设置请求超时时间
//        done(.success(request))
//    }
    
}

public final class RequestLoadingPlugin: PluginType {

    public func willSend(_ request: RequestType, target: TargetType) {
        let api = target as! API
        
        // 打印请求url
        #if DEBUG
            switch api.task {
            case .requestParameters(let parameters, _):
                print(api.baseURL.absoluteString + api.path + ((parameters as NSDictionary?)?.keyValues() ?? ""))
            default:
                print(api.baseURL.absoluteString + api.path)
            }
        #endif

    }
    
//    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        switch result {
//        case .success(let response):
//            if let headerFields = response.response?.allHeaderFields as? [String: String],
//                let URL = response.request?.url
//            {
//                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
//                PrintLog(cookies)
//                for cookie in cookies {
//                    PrintLog(cookie.name)
//                    PrintLog(cookie.value)
//                }
////                if let cookie = cookies.first, let expiresDate = cookie.expiresDate  {
////                    if expiresDate.compare(Date()) == ComparisonResult.orderedAscending {
////                        // cookie已过期
////                        DispatchQueue.main.async {
////                            CACoreLogic.pressentLoginVC()
////                        }
////                    }
////                }
////                HTTPCookieStorage.shared.removeCookies(since: Date())
////                PrintLog(HTTPCookieStorage.shared.cookies)
////                HTTPCookieStorage.shared.setCookies(cookies, for: nil, mainDocumentURL: nil)
//            }
//            break
//        case .failure(let error):
//            PrintLog(error)
//            break
//        }
//    }

}
