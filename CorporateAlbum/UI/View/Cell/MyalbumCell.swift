
//
//  MyalbumCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/31.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class MyalbumCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var expireDateOutlet: UILabel!
    @IBOutlet weak var fundsOutlet: UILabel!
    @IBOutlet weak var siteOnLineOutlet: UIButton!
    @IBOutlet weak var enabledAwardOutlet: UIButton!
    
    public var siteSettingCallBack: ((CAMySiteModel)->())?
    public var siteLogCallBack: ((CAMySiteModel)->())?

    @IBAction func userActions(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            // 站点设置
            siteSettingCallBack?(model)
        case 1001:
            // 站点日志
            siteLogCallBack?(model)
        default:
            break
        }
    }
    
    var model: CAMySiteModel! {
        didSet {
            coverOutlet.setImage(model.Logo)
            titleOutlet.text = model.SiteTitle
            expireDateOutlet.text = model.ExpireDate
            fundsOutlet.text = "￥\(model.Funds)"
            siteOnLineOutlet.setTitle(model.IsOnline ? "站点在线" : "站点离线",
                                      for: .normal)
            enabledAwardOutlet.setTitle(model.EnabledAward ? "奖励启用" : "奖励禁用",
                                      for: .normal)
        }
    }
}
