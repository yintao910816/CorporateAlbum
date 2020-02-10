//
//  DiskImage.swift
//  StoryReader
//
//  Created by 尹涛 on 2018/4/23.
//  Copyright © 2018年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

enum ImageError: Swift.Error {
    case InvalidURL
    case EmptyImage
}

enum CacheDir {
    case documents
    case caches
    case tmp
}

extension CacheDir {
    
    var path: String {
        get {
            switch self {
            case .documents:
                return DocumentsDir() + "/"
            case .caches:
                return CachesDir() + "/"
            case .tmp:
                return TmpDir()
            }
        }
    }
}

enum ImageType {
    case png
    case jpg
}

extension ImageType {
    var typeString: String {
        get {
            switch self {
            case .jpg:
                return ".jpg"
            case .png:
                return ".png"
            }
        }
    }
}

extension ImageError {
    func mapError() ->String {
        switch self {
        case .InvalidURL:
            return "无效的图片地址"
        case .EmptyImage:
            return "此地址下无有效图片"
        }
    }
}

//MARK:
//MARK: 下载图片
func DownImage(url: String, complement: @escaping (((UIImage?, String?)) ->Void)) throws{
    if let _url = URL.init(string: url) {
        ImageDownloader.default.downloadImage(with: _url, progressBlock: { (receivedSize, totleSize) in
            
        }) { (image, error, imageUrl, data) in
            complement((image, imageUrl?.absoluteString))
        }
    }else {
        throw ImageError.InvalidURL
    }
}

//MARK:
//MARK: 手动将下载的图片存入沙盒Tmp下
func SaveImage(toSandox image: UIImage,
               key: String,
               folder: String,
               _ cache: CacheDir,
               _ imageType: ImageType = .jpg) {

    DispatchQueue.global().async {
        do {
            let cacheDir = cache.path + folder
            if FileManager.default.fileExists(atPath: cacheDir) == false {
                try FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: true, attributes: nil)
            }
            if let cacheURL = URL(string:"file://" +  cacheDir)?.appendingPathComponent(key + imageType.typeString) {
                try image.jpegData(compressionQuality: 1)?.write(to: cacheURL)
            }
        } catch {
            PrintLog(error)
        }
    }
}

/**
 * app 零时缓存图片路径
 */
let AppImageCacheTmpDir = "images/"
