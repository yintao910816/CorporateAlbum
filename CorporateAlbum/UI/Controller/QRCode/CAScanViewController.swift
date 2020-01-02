//
//  CAScanViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/13.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

private let urlFormat = "^http[s]?://([\\w-]+\\.)+[\\w-]+([\\w-./?%&*=]*)$"
private let siteUrlFormat = "dazongg.com"
private let bookUrlFormat = "yangguang.dazongg.com/?book="
//private let siteUrlFormat = "^http[s]?://([\\w-]+\\.yangguang.dazongg.com)[\\/]?$"
//private let bookUrlFormat = "^http[s]?://([\\w-]+\\.yangguang.dazongg.com)\\?book=([\\w-]+)$"

class CAScanViewController: ScanCodeController {

    override func setupUI() {
        navigationItem.title = "扫一扫"
    }
        
    override func scanResult(result: String?) {
        guard let resultObj = result else {
            NoticesCenter.alert(title: "提示", message: "没有扫描到信息")
            return
        }
        
//        var predicate =  NSPredicate(format: "SELF MATCHES %@" ,bookUrlFormat)
        if resultObj.contains(bookUrlFormat) == true {
            let bookInfoVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bookInfoID") as! CAAlbumInfoViewController
            bookInfoVC.prepare(parameters: ["bookId": resultObj.components(separatedBy: "=").last!])
            navigationController?.pushViewController(bookInfoVC, animated: true)
            
            userDefault.isPopToRoot = true
            return
        }

//        predicate =  NSPredicate(format: "SELF MATCHES %@" ,siteUrlFormat)
        if resultObj.contains(siteUrlFormat) == true {
            let temp = resultObj.components(separatedBy: "/")
            var siteName = ""
            for content in temp {
                if content.contains(siteUrlFormat) == true {
                    siteName = content
                    break
                }
            }
            let bookInfoVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "siteAlbumCtrlID") as! CASiteAlbumBookViewController
            bookInfoVC.prepare(parameters: ["siteName": siteName])
            navigationController?.pushViewController(bookInfoVC, animated: true)
            
            userDefault.isPopToRoot = true
            return
        }

        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,urlFormat)
        if predicate.evaluate(with: resultObj) {
            let webVC = WebViewController()
            webVC.htmlURL = resultObj
            navigationController?.pushViewController(webVC, animated: true)
            
            userDefault.isPopToRoot = true
            return
        }

        let remindVC = CAScanRemindViewController.init(nibName: "CAScanRemindViewController", bundle: Bundle.main)
        remindVC.prepare(parameters: ["text": resultObj])
        navigationController?.pushViewController(remindVC, animated: true)
    }

}
