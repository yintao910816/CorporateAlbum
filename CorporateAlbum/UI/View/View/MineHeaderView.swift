//
//  MineHeaderView.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/7.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class MineHeaderView: BaseFilesOwner {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var avatarOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var accountOutlet: UILabel!
    @IBOutlet weak var fundsOutlet: UILabel!
    
    @IBOutlet weak var todayFoundsOutlet: UILabel!
    @IBOutlet weak var monthFoundsOutlet: UILabel!
    @IBOutlet weak var totleFundsOutlet: UILabel!
    
    @IBOutlet weak var remindOutlet: UILabel!
    @IBOutlet weak var avatarBottomCns: NSLayoutConstraint!
    
    var userInfoObser = Variable((UserInfoModel(), CASumIncomeModel(), false))

    public let avatarTapSubject = PublishSubject<UserInfoModel>()
    
    init(disposebag: DisposeBag) {
        super.init()
        
        contentView = (Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView)
        
        if CACoreLogic.share.isInCheck {
            avatarBottomCns.constant = -25
        }
        
        userInfoObser.asDriver()
            .skip(1)
            .drive(onNext: { [unowned self] data in
                let user = data.0
                let sumInfo = data.1
                
                if user.Id.count > 0 {
                    self.remindOutlet.isHidden = true
                    self.nickNameOutlet.isHidden = false
                    self.fundsOutlet.isHidden = false
                    self.todayFoundsOutlet.isHidden = false
                    self.monthFoundsOutlet.isHidden = false
                    self.totleFundsOutlet.isHidden = false

                    self.avatarOutlet.setImage(user.PhotoUrl, .userIcon)
                    self.nickNameOutlet.text = user.NickName
                    self.accountOutlet.text = "账号: \(user.Mobile)"
                    self.fundsOutlet.text = "钱包: ￥\(user.Funds)元"
                    
                    self.todayFoundsOutlet.attributedText = sumInfo.todayIncomeText
                    self.monthFoundsOutlet.attributedText = sumInfo.monthIncomeText
                    self.totleFundsOutlet.attributedText = sumInfo.totalIncomeText
                    
                    self.fundsOutlet.isHidden = data.2
                    self.todayFoundsOutlet.isHidden = data.2
                    self.monthFoundsOutlet.isHidden = data.2
                    self.totleFundsOutlet.isHidden = data.2
                }else {
                    self.remindOutlet.isHidden = false
                    self.nickNameOutlet.isHidden = true
                    self.fundsOutlet.isHidden = true
                    self.todayFoundsOutlet.isHidden = true
                    self.monthFoundsOutlet.isHidden = true
                    self.totleFundsOutlet.isHidden = true

                    self.avatarOutlet.setImage(nil, .userIcon)
                }
            })
            .disposed(by: disposebag)
        
        avatarOutlet.rx.tap.asObservable()
            .map{ [unowned self] _ in self.userInfoObser.value.0 }
            .bind(to: avatarTapSubject)
            .disposed(by: disposebag)
    }
}
