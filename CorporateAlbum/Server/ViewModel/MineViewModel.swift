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
import RxDataSources

class MineViewModel: BaseViewModel , VMNavigation{
    
    var datasource = Variable([SectionModel<Int, MineCellModel>]())
    var userInfoObser = Variable((UserInfoModel(), CASumIncomeModel()))
    
//    var userIsLogin = false
    
    let userIsLoginObser = Variable(true)
    
    override init() {
        super.init()
        
        let sections = [SectionModel.init(model: 0, items: [MineCellModel.init("账号设置"),
                                                            MineCellModel.init("奖励提现"),
                                                            MineCellModel.init("开通画册"),
                                                            MineCellModel.init("我的订单"),
                                                            MineCellModel.init("我的画册")]),
                        SectionModel.init(model: 1, items: [MineCellModel.init("关于我们"),
                                                            MineCellModel.init("退出登录")])]
        
        datasource.value = sections
        
        UserInfoModel.loginUser { [unowned self] user in
            if let _user = user, _user.Id.count > 0 {
                self.userInfoObser.value = (_user, CASumIncomeModel())
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
//                var tempDatas = self.datasource.value
//                var model = tempDatas.last!
//                if model.title == "去登录" && ret == true {
//                    model.title = "退出登录"
//                }else if  model.title == "退出登录" && ret == false {
//                    model.title = "去登录"
//                }
//                tempDatas.removeLast()
//                tempDatas.append(model)
//                self.datasource.value = tempDatas
            })
            .disposed(by: disposeBag)
    }
    
    private func getUserInfoRequest() {
        let userInfoSignal = CARProvider.rx.request(.getUserInfo())
            .map(model: UserInfoModel.self)
            .asObservable()
            .catchErrorJustReturn(UserInfoModel())

        let sumInfoSignal = CARProvider.rx.request(.sumIncome)
            .map(model: CASumIncomeModel.self)
            .asObservable()
            .catchErrorJustReturn(CASumIncomeModel())

        Observable.combineLatest(userInfoSignal, sumInfoSignal)
            .subscribe(onNext: { data in
                if data.0.Id.count > 0 {
                    self.userInfoObser.value = data
                    
                    self.userIsLoginObser.value = true
                    userDefault.uid = data.0.Id
                    data.0.insertUser()
                }else {
                    self.userIsLoginObser.value = false
                    userDefault.uid = nil
                }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
}

struct MineCellModel {
    var title: String!
    
    init(_ title: String) {
        self.title = title
    }
}
