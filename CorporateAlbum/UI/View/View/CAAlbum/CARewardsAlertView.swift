//
//  CARewardsAlertView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/7.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CARewardsAlertView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var rewardsMoneyOutlet: UILabel!
    @IBOutlet weak var titleOutlet: UILabel!
    
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var getRewardsOutlet: UIButton!
    
    public var getRewardsCallBack: ((AlbumPageModel)->())?
    
    @IBAction func actions(_ sender: UIButton) {
        excuteAnimotion()
        getRewardsCallBack?(model)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CARewardsAlertView", owner: self, options: nil)?.first as! UIView)
        contentView.frame = bounds
        addSubview(contentView)
        
        getRewardsOutlet.layer.cornerRadius = 5
        getRewardsOutlet.layer.borderColor = RGB(253, 176, 149).cgColor
        getRewardsOutlet.layer.borderWidth = 2
        
        titleOutlet.text = "老板又发红包啦\n抢到才算噢！"
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        
        excuteAnimotion(animotion: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PrintLog("释放了 \(self)")
    }
    
    @objc private func tapAction() {
        excuteAnimotion()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
    
    public var model: AlbumPageModel! {
        didSet {
            iconOutlet.setImage(model.AppLogo)
            coverOutlet.setImage(model.SiteLogo)
            
            let rewardsText = String.init(format: "%.2f元", Float(model.PageAward) / 100.00)
            rewardsMoneyOutlet.attributedText = rewardsText.attributed(NSRange.init(location: rewardsText.count - 1, length: 1),
                                                                       rewardsMoneyOutlet.textColor,
                                                                       .systemFont(ofSize: 13))
        }
    }
}

extension CARewardsAlertView {
    
    public func excuteAnimotion(animotion: Bool = true) {
        if animotion {
            if isHidden {
                PrintLog("显示")
                isHidden = false
                contentBgView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.25) {
                    self.contentBgView.transform = CGAffineTransform.identity
                }
            }else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.contentBgView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                }) { finish in
                    if finish {
                        self.isHidden = true
                        PrintLog("隐藏")
                    }
                }
            }
        }else {
            if isHidden {
                PrintLog("显示 11")
                contentBgView.transform = CGAffineTransform.identity
            }else {
                contentBgView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                isHidden = true
                PrintLog("隐藏 11")
            }
        }
    }
}
