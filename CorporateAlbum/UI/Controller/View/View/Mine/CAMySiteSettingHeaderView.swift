//
//  CAMySiteSettingHeaderView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAMySiteSettingHeaderView: UIView {

    public static let viewHeight: CGFloat = 499

    /// 界面跳转（界面 segue）
    public var actonCallBack:((CASiteSettingType)->())?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewForCheck: UIImageView!
    
    @IBAction func actions(_ sender: UIButton) {
        var copyText: String?
        switch sender.tag {
        case 200:
            // 网站标题
            copyText = model.SiteTitle
        case 201:
            // 网站地址
            copyText = model.SiteUrl
        case 202:
            // 管理密码
            copyText = model.ManagePassword
        
        case 300:
            // 管理密码 - 修改密码
            actonCallBack?(.editManagePwd)
        case 301:
            // 续期
            if !CACoreLogic.share.isInCheck {
                actonCallBack?(.renewal)
            }
        case 302:
            // 充值
            if !CACoreLogic.share.isInCheck {
                actonCallBack?(.recharge)
            }
        case 303:
            // 推广区域
            actonCallBack?(.extensionAreaSetting)
        default:
            break
        }
        
        if copyText != nil {
            UIPasteboard.general.string = copyText
            NoticesCenter.alert(message: "复制成功")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAMySiteSettingHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
        
        if CACoreLogic.share.isInCheck {
            for idx in 500...503 {
                contentView.viewWithTag(idx)?.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var model: CAMySiteModel! {
        didSet {
            if CACoreLogic.share.isInCheck {
                viewForCheck.isHidden = false
                viewForCheck.setImage(model.Logo)
            }else {
                viewForCheck.isHidden = true
            }
            
            let validataDate = "\(model.CreateDate) 至 \(model.ExpireDate)"
            let textArr = [model.SiteTitle, model.SiteUrl, model.ManageUrl, model.ManageUserName, model.ManagePassword, validataDate, "￥\(model.Funds)元", "￥\(model.TotalAward)元", "\(model.AwardPageCount)页"]
            for idx in 0..<textArr.count {
                let label = (contentView.viewWithTag(100 + idx) as? UILabel)
                label?.text = textArr[idx]
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
