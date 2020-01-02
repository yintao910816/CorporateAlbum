//
//  ArchiverTools.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/8.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

func ArchiverWithRootObject<T: BaseArchiverModel>(_ rootObjcet : Any, modelType: T.Type){
//    let fileName = NSStringFromClass(fileName.classForCoder) as String
    
    let fileManager = FileManager.default
//    var savePath = CachesDir()?.appendingPathComponent(ArchiverPath)
    guard let dirPath = CachesURL()?.appendingPathComponent(ArchiverPath) else {
        PrintLog("归档失败！-- 归档文件路劲不存在")
        return
    }
    if fileManager.fileExists(atPath: dirPath.path) == false {
        do{
            try fileManager.createDirectory(atPath: dirPath.path, withIntermediateDirectories: false, attributes: nil)
        }catch {
            PrintLog("归档失败！-- 创建文件路径失败")
        }
    }
    
    let fileName = NSStringFromClass(modelType).replacingOccurrences(of: (Bundle.main.projectName + "."), with: "")
    let savePath = dirPath.path + "/" + fileName + ".plist"
    //归档
    NSKeyedArchiver.archiveRootObject(rootObjcet, toFile:savePath)
}

func Unarchiver<T: BaseArchiverModel>(modelType: T.Type)->Any?{
    guard let dirPath = CachesURL()?.appendingPathComponent(ArchiverPath) else {
        PrintLog("归档失败！-- 归档文件路劲不存在")
        return nil
    }

    let fileName = NSStringFromClass(modelType).replacingOccurrences(of: (Bundle.main.projectName + "."), with: "")
//    let fileName = NSStringFromClass(self.classForCoder) as String
    
    let savePath = dirPath.path + "/" + fileName + ".plist"
    
    //解档出来的元素
    return NSKeyedUnarchiver.unarchiveObject(withFile: savePath)
}


// 获取Home目录路径
fileprivate func HomeDir() ->String {
    return NSHomeDirectory()
}

/**
 * 获取Documents目录
 * 保存应用运行时生成的需要持久化的数据，iTunes同步设备时会备份该目录
 */
func DocumentsDir() ->String! {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
}

/**
 * 获取Caches目录
 * 保存应用运行时生成的需要持久化的数据，iTunes同步设备时不备份该目录。一般存放体积大、不需要备份的非重要数据
 */
func CachesURL() ->URL? {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
}

func CachesDir() ->String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
}

/**
 *  获取tmp目录
 *  保存应用运行时所需要的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行，系统也可能会清除该目录下的文件，iTunes不会同步备份该目录
 */
func TmpDir() ->String {
    return NSTemporaryDirectory()
}

let ArchiverPath = "Archivers"
