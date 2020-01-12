
//
//  CAAccountHeaderView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAAccountHeaderView: UIView {

    enum ActionType {
        case nickName
        case phone
        case alipay
        case city
        case avatar
    }
    
    @IBOutlet weak var accountNumOutlet: UILabel!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var phoneOutlet: UILabel!
    @IBOutlet weak var alipayOutlet: UILabel!
    @IBOutlet weak var cityOutlet: UILabel!
    @IBOutlet weak var iconOutlet: UIImageView!
    
    @IBOutlet var contentView: UIView!
    
    public var selectedCallBack:(((ActionType, String, [String: Any]))->())?
    
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
            selectedCallBack?((.nickName, "editNickNameSegue", ["model": model]))
        case 203:
            // 手机号码
            selectedCallBack?((.phone ,"editPhoneSegue", ["model": model]))
        case 204:
            // 支付宝账号
//            selectedCallBack?((.alipay ,"setAlipaySegue", ["model": model]))
            NoticesCenter.alert(message: "开发中，敬请期待...")
        case 205:
            // 所在城市
            selectedCallBack?((.city ,"setCitySegue", ["model": model]))
        case 206:
            // 更换头像
            selectedCallBack?((.avatar ,"", [:]))
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
    
    public func reloadAvatar(_ avatar: UIImage?) {
        iconOutlet.image = avatar
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
}
