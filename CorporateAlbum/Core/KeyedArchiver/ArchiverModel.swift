//
//  ArchiverModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/8.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class BaseArchiverModel: HJModel {

    // MARK: - 系统回调函数
    required init() {
        super.init()
    }
        
    // MARK: - 归档与解档
    //    归档
    func encode(with aCoder: NSCoder) {
        //        let a: JSONSerialization = <#value#>
        
        //        1.获取所有属性
        //        1.1.创建保存属性个数的变量
        var count: UInt32 = 0
        //        1.2.获取变量的指针
        let outCount: UnsafeMutablePointer<UInt32> = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }
        //        1.3.获取属性数组
        let ivars = class_copyIvarList(Person.self, outCount)
        for i in 0..<outCount.pointee {
            //            2.获取键值对
            //            2.1.获取ivars中的值
            let ivar = ivars![Int(i)];
            //            2.2.获取键
            let ivarKey = String(cString: ivar_getName(ivar)!)
            //            2.3.获取值
            let ivarValue = value(forKey: ivarKey)
            
            //            3.归档
            aCoder.encode(ivarValue, forKey: ivarKey)
        }
        
        //        4.释放内存
        free(ivars)
    }
    
    //    解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        //        1.获取所有属性
        //        1.1.创建保存属性个数的变量
        var count: UInt32 = 0
        //        1.2.获取变量的指针
        let outCount = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }
        //        1.3.获取属性数组
        let ivars = class_copyIvarList(Person.self, outCount)
        for i in 0..<count {
            //            2.获取键值对
            //            2.1.获取ivars中的值
            let ivar = ivars![Int(i)]
            //            2.2.获取键
            let ivarKey = String(cString: ivar_getName(ivar)!)
            //            2.3.获取值
            let ivarValue = aDecoder.decodeObject(forKey: ivarKey)
            
            //            3.设置属性的值
            setValue(ivarValue, forKey: ivarKey)
        }
        
        //        4.释放内存
        free(ivars)
    }
}
