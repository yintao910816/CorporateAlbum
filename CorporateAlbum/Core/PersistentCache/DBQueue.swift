//
//  DBQueue.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/7/19.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

class DBQueue {
    
    static let share = DBQueue()
    
    public let queue = DispatchQueue.init(label: "queue", qos: .default)
}

import SQLite
extension DBQueue {

    public final func insterQueue<T: DBOperation>(_ setters: [Setter], _ tbName: String, _ type: T.Type) {
        queue.async {
            type.dbInster(setters, tbName, type)
        }
    }

    public final func insterOrUpdateQueue<T: DBOperation>(model: T,
                                                          _ tbName: String,
                                                          _ type: T.Type){
        queue.async {
            type.dbInsterOrUpdate(model.insertFilier(), model.setters(), tbName, type)
        }
    }
    
    public final func insterOrUpdateQueue<T: DBOperation>(models: [T],
                                                          _ tbName: String,
                                                          _ type: T.Type){
        queue.async {
            for data in models {
                type.dbInsterOrUpdate(data.insertFilier(), data.setters(), tbName, type)
            }
        }
    }
    
    public final func selectQueue<T: DBOperation>(_ filier: Expression<Bool>,
                                  order aorder: [Expressible]? = nil,
                                  _ tbName: String,
                                  limit alimit: Int? = nil,
                                  _ type: T.Type,
                                  complement: @escaping ((Table?) ->Void)){
        queue.async {
            let table = type.dbSelect(filier, order: aorder, tbName, limit: alimit, type)
            DispatchQueue.main.async {
                complement(table)
            }
        }
    }
    
    public final func updateQueue<T: DBOperation>(_ filier: Expression<Bool>,
                             _ setters: [Setter],
                             _ tbName: String,
                             _ type: T.Type) {
    
        queue.async {
            type.dbUpdate(filier, setters, tbName, type)
        }
    }
    
    public final func deleteRowQueue<T: DBOperation>(_ filier: Expression<Bool>, _ tbName: String, _ type: T.Type) {
        queue.async {
            type.db_deleteRow(filier, tbName, type)
        }
    }

}

import Photos
extension DBQueue {
    
    typealias saveComplement = ((Bool, String)) ->Void

    public final func save(toPhotosAlbum image: UIImage, complement: saveComplement? = nil) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            saveOK(toPhotosAlbum: image, complement: complement)
        case .denied, .restricted:
            if let c = complement {
                c((false, "获取相册权限失败！"))
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                if newStatus == .authorized {
                    self?.saveOK(toPhotosAlbum: image, complement: complement)
                }else {
                    if let c = complement {
                        c((false, "获取相册权限失败！"))
                    }
                }
            }
        }
    }
    
    private func saveOK(toPhotosAlbum image: UIImage, complement: saveComplement? = nil) {
        queue.async {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAsset(from: image) }, completionHandler: { (ret, error) in
                if let c = complement {
                    if ret == true {
                        c((true, "已保存到相册!"))
                    }else { c((false, error?.localizedDescription ?? "保存失败")) }
                }
            })
        }
    }
    
}
