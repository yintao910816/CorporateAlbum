
//
//  CAAccountHeaderView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAAccountHeaderView: UIView {

    @IBOutlet weak var accountNumOutlet: UILabel!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var phoneOutlet: UILabel!
    @IBOutlet weak var alipayOutlet: UILabel!
    @IBOutlet weak var cityOutlet: UILabel!
    @IBOutlet weak var iconOutlet: UIImageView!
    
    @IBOutlet var contentView: UIView!
    
    public var selectedCallBack:(((String, [String: Any]))->())?
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            // 复制
            UIPasteboard.general.string = accountNumOutlet.text
            NoticesCenter.alert(message: "复制成功")
        case 201:
            // 会员编号
            break
        case 202:
            // 昵称
            selectedCallBack?(("editNickNameSegue", ["model": model]))
        case 203:
            // 手机号码
            selectedCallBack?(("editPhoneSegue", ["model": model]))
        case 204:
            // 支付宝账号
            break
        case 205:
            // 所在城市
            break
        case 206:
            // 更换头像
            break
        default:
            break
        }
    }
    
    public class var viewHeight: CGFloat { return 294 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAAccountHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var model: UserInfoModel! {
        didSet {
            accountNumOutlet.text = model.Id
            nickNameOutlet.text = model.NickName
            phoneOutlet.text = model.Mobile
            alipayOutlet.text = model.Alipay
            cityOutlet.text = model.RegionTitle
            iconOutlet.setImage(model.PhotoUrl)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
}
