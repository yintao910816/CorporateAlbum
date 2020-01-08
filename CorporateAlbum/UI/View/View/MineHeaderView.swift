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
    @IBOutlet weak var fundsOutlet: UILabel!
    @IBOutlet weak var remindOutlet: UILabel!
    
    var userInfoObser = Variable(UserInfoModel())

    init(disposebag: DisposeBag) {
        super.init()
        
        contentView = (Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView)
        
        userInfoObser.asDriver()
            .skip(1)
            .drive(onNext: { [unowned self] user in
                if user.Id.count > 0 {
                    self.remindOutlet.isHidden = true
                    self.nickNameOutlet.isHidden = false
                    self.fundsOutlet.isHidden = false
                    
                    self.avatarOutlet.setImage(user.PhotoUrl, .userIcon)
                    self.nickNameOutlet.text = user.NickName
                    self.fundsOutlet.text = "资金：\(user.Funds)"
                }else {
                    self.remindOutlet.isHidden = false
                    self.nickNameOutlet.isHidden = true
                    self.fundsOutlet.isHidden = true
                    
                    self.avatarOutlet.setImage(nil, .userIcon)
                }
            })
            .disposed(by: disposebag)
    }
}
