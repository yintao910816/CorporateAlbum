
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
    @IBOutlet weak var controlUrlOutlet: UILabel!
    
    weak var delegate: SiteOperations?
    
    @IBAction func userActions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            delegate?.rewardSetting(model: model)
            break
        case 101:
            delegate?.statusSetting(model: model)
            break
        case 102:
            NoticesCenter.alert(title: "操作提示", message: "重设奖励即重新开始奖励，让所有已经获得浏览奖励的会员可以重新获得奖励，确定要继续吗？", cancleTitle: "取消", okTitle: "确定", isLeft: true) { [unowned self] in
                self.delegate?.resetReward(model: self.model)
            }
            break
        case 103:
            delegate?.recharge(model: model)
            break
        default:
            break
        }
    }
    
    var model: SiteInfoModel! {
        didSet {
            coverOutlet.setImage(model.Logo)
            titleOutlet.text = model.SiteTitle
            expireDateOutlet.text = "有效期：\(model.ExpireDate)"
            fundsOutlet.text = "资金余额：\(model.Funds)"
            controlUrlOutlet.text = "管理地址：\(model.ControlUrl)"
            
            (contentView.viewWithTag(100) as! UIButton).setTitle(model.awardStateText, for: .normal)
            (contentView.viewWithTag(101) as! UIButton).setTitle(model.siteStateText, for: .normal)
            (contentView.viewWithTag(101) as! UIButton).isEnabled = model.SiteState != 2
        }
    }
}

protocol SiteOperations: class {
    
    /**
     * 禁/启用奖励
     */
    func rewardSetting(model: SiteInfoModel)
    
    /**
     * 离/在线设置
     */
    func statusSetting(model: SiteInfoModel)
    
    /**
     * 重设奖励
     */
    func resetReward(model: SiteInfoModel)
    
    /**
     * 续单/充值
     */
    func recharge(model: SiteInfoModel)
}

