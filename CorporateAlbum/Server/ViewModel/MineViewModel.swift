//
//  MineViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MineViewModel: BaseViewModel , VMNavigation{
    
    var datasource = Variable([MineCellModel]())
    var userInfoObser = Variable(UserInfoModel())
    
//    var userIsLogin = false
    
    let userIsLoginObser = Variable(true)
    
    override init() {
        super.init()
        
        datasource.value = [MineCellModel.init("账号设置"),
                            MineCellModel.init("收益明细"),
                            MineCellModel.init("奖励提现"),
                            MineCellModel.init("我的通知"),
                            MineCellModel.init("我的站点"),
                            MineCellModel.init("我要建站"),
                            MineCellModel.init("使用帮助"),
                            MineCellModel.init("退出登录")]
        
        UserInfoModel.loginUser { [unowned self] user in
            if let _user = user, _user.Id.count > 0 {
                self.userInfoObser.value = _user
                self.userIsLoginObser.value = true
            }else {
                self.userIsLoginObser.value = false
            }
        }
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.getUserInfoRequest()
        })
        .disposed(by: disposeBag)
        
        userIsLoginObser.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] ret in
                var tempDatas = self.datasource.value
                var model = tempDatas.last!
                if model.title == "去登录" && ret == true {
                    model.title = "退出登录"
                }else if  model.title == "退出登录" && ret == false {
                    model.title = "去登录"
                }
                tempDatas.removeLast()
                tempDatas.append(model)
                self.datasource.value = tempDatas
            })
            .disposed(by: disposeBag)
    }
    
    private func getUserInfoRequest() {
        CARProvider.rx.request(.getUserInfo())
            .map(model: UserInfoModel.self)
            .subscribe(onSuccess: { [unowned self] model in
                if model.Id.count > 0 {
                    self.userIsLoginObser.value = true
                    userDefault.uid = model.Id
                    model.insertUser()
                }else {
                    self.userIsLoginObser.value = false
                    userDefault.uid = nil
                }
                self.userInfoObser.value = model
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
}

struct MineCellModel {
    var title: String!
    
    init(_ title: String) {
        self.title = title
    }
}
