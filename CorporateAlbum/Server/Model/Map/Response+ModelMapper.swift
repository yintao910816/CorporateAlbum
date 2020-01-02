//
//  TResponse+ModelMapper.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/10/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

public extension Response {

    // 处理查询结果为空
//    private func dealEmptyResult(_ message: MessageModel) ->Bool { return message.content == "查询结果为空" }
//
//    internal func mapResponse() throws -> ResponseModel {
//        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        guard let serverModel = JSONDeserializer<ResponseModel>.deserializeFrom(dict: jsonDictionary) else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        if serverModel.success == true {
//            return serverModel
//        }else {
//            if dealEmptyResult(serverModel.message) == true {
//                return serverModel
//            }
//            throw MapperError.server(message: serverModel.message.content)
//        }
//    }
//
//    internal func map<T: HandyJSON>(model type: T.Type) throws -> T {
//        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        if serverModel.success == true, let model = serverModel.data {
//            return model
//        }else {
//            if dealEmptyResult(serverModel.message) == true {
//                return T()
//            }
//            throw MapperError.server(message: serverModel.message.content)
//        }
//    }
//
//    internal func map<T: HandyJSON>(model type: T.Type) throws -> [T] {
//        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        if serverModel.success == true, let models = serverModel.data {
//            return models
//        }else {
//            if dealEmptyResult(serverModel.message) == true {
//                return [T]()
//            }
//            throw MapperError.server(message: serverModel.message.content)
//        }
//    }
//
//    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<T> {
//        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        guard let serverModel = JSONDeserializer<DataModel<T>>.deserializeFrom(dict: jsonDictionary) else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        if serverModel.success == true {
//            return serverModel
//        }else {
//            if dealEmptyResult(serverModel.message) == true {
//                return serverModel
//            }
//            throw MapperError.server(message: serverModel.message.content)
//        }
//    }
//
//    internal func map<T: HandyJSON>(result type: T.Type) throws -> DataModel<[T]> {
//        guard let jsonDictionary = try mapJSON() as? [String: Any] else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        guard let serverModel = JSONDeserializer<DataModel<[T]>>.deserializeFrom(dict: jsonDictionary) else {
//            throw MapperError.json(message: "json解析失败")
//        }
//
//        if serverModel.success == true {
//            return serverModel
//        }else {
//            if dealEmptyResult(serverModel.message) == true {
//                return serverModel
//            }
//            throw MapperError.server(message: serverModel.message.content)
//        }
//    }
    
        internal func _mapResponseStatus() throws -> ResponseStatusModel {
            guard let jsonDictionary = try mapJSON() as? NSDictionary else {
                throw MapperError.json(message: "json解析失败")
            }
            guard let serverModel = JSONDeserializer<ResponseStatusModel>.deserializeFrom(dict: jsonDictionary) else {
                throw MapperError.json(message: "json解析失败")
            }
            return serverModel            
    }
    
    internal func _map<T: HandyJSON>(model type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary else {
            throw MapperError.json(message: "json解析失败")
        }
        
        guard let serverModel = JSONDeserializer<T>.deserializeFrom(dict: jsonDictionary) else {
            throw MapperError.json(message: "json解析失败")
        }
        return serverModel
    }

    internal func _map<T: HandyJSON>(models type: T.Type) throws -> [T] {
        guard let json = try mapJSON() as? [[String:Any]] else {
            throw MapperError.json(message: "json解析失败")
        }
        
        guard let serverModel = JSONDeserializer<T>.deserializeModelArrayFrom(array: json) else {
            throw MapperError.json(message: "json解析失败")
        }
        
        return serverModel as! [T]
    }
}

enum MapperError: Swift.Error {
    case ok(message: String?)
    case json(message: String?)
    case server(message: String?)
}

extension MapperError {
    
    public var message: String {
        switch self {
        case .ok(let text):
            return (text ?? "操作成功!")
        case .json(let text):
            return (text ?? "解析失败！")
        case .server(let text):
            return text ?? "错误：52000"
        }
    }
}
