//
//  RegionInfo.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CARegionInfoModel: HJModel {
    /// 区域邮政编号
    var Code: String = ""
    /// 区域名称
    var Title: String = ""
}

//MARK:
//MARK: 本地区域数据
class CARegionListModel {
    var name: String = ""
    var code: String = ""
    var pinyin: String = ""
    var province: String = ""
    var city: String = ""
    var district: String = ""
    
    var firstLetter: String = ""
    
    public static func prepareRegionListData( complement: @escaping (([(key: String, value: [CARegionListModel])])->())) {
        DispatchQueue.global().async {
            var datas: [String: [CARegionListModel]] = [:]
            guard let rows = CARegionListModel.selected() else {
                DispatchQueue.main.async {
                    complement([])
                }
                return
            }
            
            for row in rows {
                let model = CARegionListModel();
                model.name     = row[nameEx]
                model.code     = row[codeEx]
                model.pinyin   = row[pinyinEx]
                model.firstLetter = model.pinyin.substring(to: 1)
                model.province  = row[provinceEx] ?? ""
                model.city     = row[cityEx] ?? ""
                model.district = row[districtEx] ?? ""
                
                if datas[model.firstLetter] == nil {
                    datas[model.firstLetter] = [CARegionListModel]()
                }
                
                datas[model.firstLetter]?.append(model)
            }
            
            let sortedDatas = datas.sorted { (arg0, arg1) -> Bool in
                if(arg0.key < arg1.key) {
                    return true
                }
                return false
            }
                             
            DispatchQueue.main.async {
                complement(sortedDatas)
            }
        }
    }
}

import SQLite

private let nameEx     = Expression<String>("c_name")
private let codeEx     = Expression<String>("c_code")
private let pinyinEx     = Expression<String>("c_pinyin")
private let provinceEx     = Expression<String?>("c_province")
private let cityEx     = Expression<String?>("c_city")
private let districtEx     = Expression<String?>("c_district")

extension CARegionListModel {
    
    private static var db: Connection? {
        let path = Bundle.main.resource(for: "cities", type: "db")
        PrintLog("本地推广区域数据库路径：\(path)")
        do {
            return try Connection(path)
        } catch {
            PrintLog("连接到本地推广区域数据库失败")
        }
        return nil
    }

    private static func selected() ->[Row]? {
        guard let db = CARegionListModel.db else {
            return nil
        }

        let table = Table("cities")
        
        do {
           return Array(try db.prepare(table))
        } catch  {
            PrintLog("查询所有本地推广区域数据失败: \(error)")
        }
        return nil
    }
}
