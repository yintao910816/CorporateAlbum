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
                     
        loadLocalUser()
        
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
        
        NotificationCenter.default.rx.notification(NotificationName.User.reloadUserInfo, object: nil)
            .map{ _ in true }
            .bind(to: reloadSubject)
            .disposed(by: disposeBag)
    }
    
    private func prepareCellData() {
        let sections = [SectionModel.init(model: 0, items: [MineCellModel(title: "账号设置",
                                                                          icon: UIImage(named: "mine_account_setting"),
                                                                          segue: "accountSegue",
                                                                          params: ["model":userInfoObser.value.0]),
                                                            MineCellModel(title: "奖励提现",
                                                                          icon: UIImage(named: "mine_funds"),
                                                                          segue: "refundsSegue",
                                                                          params: ["model":userInfoObser.value.0]),
                                                            MineCellModel(title: "开通画册",
                                                                          icon: UIImage(named: "mine_open_album"),
                                                                          segue: "openAlbumSegue",
                                                                          params: ["model":userInfoObser.value.0]),
                                                            MineCellModel(title: "我的订单",
                                                                          icon: UIImage(named: "mine_order"),
                                                                          segue: "orderSegue"),
                                                            MineCellModel(title: "我的画册",
                                                                          icon: UIImage(named: "mine_album"),
                                                                          segue: "myalbumSegue")]),
                        SectionModel.init(model: 1, items: [MineCellModel(title: "关于我们",
                                                                          icon: UIImage(named: "mine_about"),
                                                                          webURL: APIAssistance.aboutusWeb),
                                                            MineCellModel(title: "退出登录",
                                                                          icon: UIImage(named: "mine_login_out"),
                                                                          isLoginOut: true)])]
        
        datasource.value = sections
    }
    
    private func getUserInfoRequest() {
        let userInfoSignal = CARProvider.rx.request(.getUserInfo)
            .map(model: UserInfoModel.self)
            .asObservable()
            .catchErrorJustReturn(UserInfoModel())

        let sumInfoSignal = CARProvider.rx.request(.sumIncome)
            .map(model: CASumIncomeModel.self)
            .asObservable()
            .catchErrorJustReturn(CASumIncomeModel())

        Observable.combineLatest(userInfoSignal, sumInfoSignal)
            .subscribe(onNext: { [unowned self] data in
                if data.0.Id.count > 0 {
                    self.userInfoObser.value = data
                    
                    self.userIsLoginObser.value = true
                    userDefault.uid = data.0.Id
                    data.0.insertUser {
                        self.loadLocalUser()
                    }
                }else {
                    self.userIsLoginObser.value = false
                    userDefault.uid = nil
                }
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func loadLocalUser() {
        UserInfoModel.loginUser { [unowned self] user in
            if let _user = user, _user.Id.count > 0 {
                self.userInfoObser.value = (_user, CASumIncomeModel())
                self.prepareCellData()
                self.userIsLoginObser.value = true
            }else {
                self.userIsLoginObser.value = false
            }
        }
    }
}

struct MineCellModel {
    var title: String = ""
    var icon: UIImage?
    var segue: String = ""
    var params: [String: Any] = [:]
    
    var webURL: String = ""
    
    var isLoginOut: Bool = false
}
