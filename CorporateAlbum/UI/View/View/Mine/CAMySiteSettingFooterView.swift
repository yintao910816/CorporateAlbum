//
//  CAMySiteSettingFooterView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CAMySiteSettingFooterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var resetAwardsOutlet: UIButton!
    @IBOutlet weak var siteInfoOutlet: UILabel!
    @IBOutlet weak var awardInfoOutlet: UILabel!
    
    public let footerActionsSubject = PublishSubject<CASiteSettingType>()
    public let isOnlineObser = PublishSubject<Bool>()
    public let isAwardObser  = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()

    @IBAction func buttonActions(_ sender: UIButton) {
        // 重设奖励
        footerActionsSubject.onNext(.resetAward)
    }
    
    @IBAction func switchActions(_ sender: UISwitch) {
        switch sender.tag {
        case 100:
            // 开启站点
            footerActionsSubject.onNext(.controlSite)
        case 101:
            // 开启奖励
            footerActionsSubject.onNext(.controlAward)
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAMySiteSettingFooterView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        resetAwardsOutlet.layer.cornerRadius = 17.5
        resetAwardsOutlet.layer.borderColor = RGB(245, 245, 245).cgColor
        resetAwardsOutlet.layer.borderWidth = 1
        
        contentView.frame = bounds
        
        isOnlineObser
            .do(onNext: { [weak self] in (self?.contentView.viewWithTag(100) as? UISwitch)?.isOn = $0 })
            .map{ $0 == true ? "开启站点" : "关闭站点" }
            .bind(to: siteInfoOutlet.rx.text)
            .disposed(by: disposeBag)
        
        isAwardObser
            .do(onNext: { [weak self] in (self?.contentView.viewWithTag(101) as? UISwitch)?.isOn = $0 })
            .map{ $0 == true ? "开启奖励" : "关闭奖励" }
            .bind(to: awardInfoOutlet.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
