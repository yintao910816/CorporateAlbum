//
//  Observable+ObjectMapper.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/5.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

//extension ObservableType where E == Response /**根据APP定制，map中实现模型转换*/ {
//    
//    @discardableResult
//    func mapServerData() ->Observable<ServerModel> {
//        return self.flatMap { response in
//            return Observable<ServerModel>.create({ observer -> Disposable in
//                do {
//                   let jsonDict = try response.mapJSON()
//                    guard let dict = jsonDict as? NSDictionary else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    guard let serverModel = JSONDeserializer<ServerModel>.deserializeFrom(dict: dict) else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    
//                    if serverModel.success == true {
//                        observer.on(.next(serverModel))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }else {
//                        
//                        observer.on(.error(RxSwiftMoyaError.server(message: serverModel.message.content)))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                } catch {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//            })
//        }
//    }
//    /**
//     非列表数据类型，封装成SignalResponseModel返回全部数据
//     */
//    @discardableResult
//    func mapObject<T: HandyJSON>(_ type: T.Type) -> Observable<(SignalResponseModel<T>)> {
//        return self.flatMap { response in
//            return Observable<SignalResponseModel<T>>.create { observer in
//                
//                guard let dict = response as? NSDictionary else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                guard let serverModel = JSONDeserializer<SignalResponseModel<T>>.deserializeFrom(dict: dict) else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                
//                if serverModel.success == true {
//                    guard let model = JSONDeserializer<T>.deserializeFrom(dict: serverModel.data) else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    serverModel.model = model
//
//                    observer.on(.next(serverModel))
//                    observer.on(.completed)
//                    return Disposables.create()
//                    
//                }else {
//                    if serverModel.message.content == "查询结果为空" {
//                        observer.on(.next(serverModel))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    observer.on(.error(RxSwiftMoyaError.json(message: serverModel.message.content)))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//            }
//        }
//    }
//
//    /**
//     筛选出接口数据列表数据，并转成对应model返回
//     */
//    @discardableResult
//    func mapArray<T: HandyJSON>(_ type: T.Type) -> Observable<[T]> {
//
//        return self.flatMap { response in
//            return Observable<[T]>.create { observer in
//                
//                guard let dict = response as? NSDictionary else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                guard let serverModel = JSONDeserializer<ListResponseModel<T>>.deserializeFrom(dict: dict) else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                
//                if serverModel.success == true {
//                    guard let datas = serverModel.data else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    guard let models: [T] = JSONDeserializer<T>.deserializeModelArrayFromArray(array: datas) as! [T]? else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    serverModel.models = models
//                    
//                    observer.on(.next(models))
//                    observer.on(.completed)
//                    return Disposables.create()
//
//                    
//                }else {
//                
//                    observer.on(.error(RxSwiftMoyaError.json(message: serverModel.message.content)))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                
//            }
//        }
//
//}
//    
//    /**
//     列表数据类型，封装成 ListResponseModel 返回全部数据 ,列表数据封装到对应model存入ListResponseModel
//     */
//    func mapListArray<T: HandyJSON>(_ type: T.Type) -> Observable<ListResponseModel<T>> {
//        return self.flatMap { response in
//            return Observable<ListResponseModel<T>>.create { observer in
//                
//                guard let dict = response as? NSDictionary else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                guard let serverModel = JSONDeserializer<ListResponseModel<T>>.deserializeFrom(dict: dict) else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                
//                if serverModel.success == true {
//                    guard let datas = serverModel.data else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    guard let models: [T] = JSONDeserializer<T>.deserializeModelArrayFromArray(array: datas) as! [T]? else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    serverModel.models = models
//                    
//                    observer.on(.next(serverModel))
//                    observer.on(.completed)
//                    return Disposables.create()
//                    
//                }else {
//                    if self.dealEmptyResult(serverModel.message) == true {
//                        observer.on(.next(serverModel))
//                        observer.on(.completed)
//                    }else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: serverModel.message.content)))
//                        observer.on(.completed)
//                    }
//                    return Disposables.create()
//                }
//                
//            }
//        }
//    }
//    
//    /**
//      只在阅读界面获取章节信息使用，此json数据结构比较特殊
//     */
//    func mapList<T: HandyJSON>(_ type: T.Type) -> Observable<ListModel<T>> {
//        return self.flatMap { response in
//            return Observable<ListModel<T>>.create { observer in
//                
//                guard let dict = response as? NSDictionary else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                guard let serverModel = JSONDeserializer<ListModel<T>>.deserializeFrom(dict: dict) else {
//                    observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                    observer.on(.completed)
//                    return Disposables.create()
//                }
//                
//                if serverModel.success == true {
//                    guard let data = serverModel.data else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    guard let models: [T] = JSONDeserializer<T>.deserializeModelArrayFromArray(array: data["chapter"] as? Array) as! [T]? else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: "json解析失败")))
//                        observer.on(.completed)
//                        return Disposables.create()
//                    }
//                    serverModel.models = models
//                    
//                    observer.on(.next(serverModel))
//                    observer.on(.completed)
//                    return Disposables.create()
//                    
//                }else {
//                    if self.dealEmptyResult(serverModel.message) == true {
//                        observer.on(.next(serverModel))
//                        observer.on(.completed)
//                    }else {
//                        observer.on(.error(RxSwiftMoyaError.json(message: serverModel.message.content)))
//                        observer.on(.completed)
//                    }
//                    return Disposables.create()
//                }
//                
//            }
//        }
//    }
//
//    //MARK:
//    //MARK: 处理查询结果为空
//    private func dealEmptyResult(_ message: MessageModel) ->Bool { return message.content == "查询结果为空" }
//}
//
//enum RxSwiftMoyaError: Swift.Error {
//    case ok(message: String?)
//    case json(message: String?)
//    case server(message: String?)
//}
//
//extension RxSwiftMoyaError {
//
//    public var message: String {
//        switch self {
//        case .ok(let text):
//            return (text ?? "操作成功!")
//        case .json(let text):
//            return (text ?? "解析失败！")
//        case .server(let text):
//            return text ?? "错误：52000"
//        }
//    }
//}
