//
//  UserCenter.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//MARK:
//MARK: 账号设置
class AccountSetViewModel: BaseViewModel {
    
    var datasource = Variable([AccountSetCellModel]())
    
    init(userInfo: UserInfoModel) {
        super.init()
        
        datasource.value = [AccountSetCellModel.init("昵称", userInfo.NickName),
                            AccountSetCellModel.init("手机号码", userInfo.Mobile),
                            AccountSetCellModel.init("密保邮箱", userInfo.Email),
                            AccountSetCellModel.init("收款账号", userInfo.Alipay)]
        
        reloadSubject.subscribe(onNext: { [unowned self] _ in self.getUserInfoRequest() })
            .disposed(by: disposeBag)
    }
    
    private func getUserInfoRequest() {
        CARProvider.rx.request(.getUserInfo())
            .map(model: UserInfoModel.self)
            .subscribe(onSuccess: { [weak self] model in
                if model.Id.count > 0 {
                    self?.datasource.value = [AccountSetCellModel.init("昵称", model.NickName),
                                              AccountSetCellModel.init("手机号码", model.Mobile),
                                              AccountSetCellModel.init("密保邮箱", model.Email),
                                              AccountSetCellModel.init("收款账号", model.Alipay)]

                    model.insertUser()
                }

            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
}

struct AccountSetCellModel {
    var title: String!
    var detailTitle: String?

    init(_ title: String, _ detailTitle: String?) {
        self.title = title
        self.detailTitle = detailTitle
    }
}

//MARK:
//MARK: 修改昵称
class SetNickNameViewModel: BaseViewModel {
    
    var nickNameObser: Driver<Bool>!
    var authorCodeObser: Driver<Bool>!

    init(input:(authorCode: Driver<String>, nickName: Driver<String>),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        // 控制输入框边框颜色的显示
        nickNameObser = input.nickName.map{ ValidateNum.string($0, min: 3, max: 16).isRight }
        authorCodeObser = input.authorCode.map{ $0.count > 0 }
        
        // 判断是否可以提交修改昵称的请求
        let validate = Driver.combineLatest(input.authorCode, input.nickName, nickNameObser, authorCodeObser)
            .map { data -> (String, String, Bool) in
                return (data.0, data.1, data.2 && data.3)
        }
        
        tap.getAuthorCode.drive(onNext: { [unowned self] in self.getSmsCode() })
            .disposed(by: disposeBag)
        
        tap.submit.withLatestFrom(validate)
            .filter({ data -> Bool in
                if data.2 == false {
                    NoticesCenter.alert(title: "提示", message: "信息填写不正确！")
                }
                return data.2
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] data in
                self.postRequest(nickName: data.1, smsCode: data.0)
            })
            .disposed(by: disposeBag)
        
    }

    private func postRequest(nickName: String, smsCode: String) {
        CARProvider.rx.request(.setNickName(nickName: nickName, smsCode: smsCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message, {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func getSmsCode() {
        CARProvider.rx.request(.sendSmsCodeForMe())
            .mapResponse()
            .subscribe(onSuccess: { model in
                if model.error == 0 {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }else {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}

//MARK:
//MARK: 修改手机号码
class SetPhoneViewModel: BaseViewModel {
    
    var phoneObser: Driver<Bool>!
    var authorCodeObser: Driver<Bool>!

    init(input:(authorCode: Driver<String>, newPhone: Driver<String>),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        phoneObser = input.newPhone.map{ ValidateNum.phoneNum($0).isRight }
        authorCodeObser = input.authorCode.map{ $0.count > 0 }
        
        // 判断是否可以提交修的请求
        let validate = Driver.combineLatest(input.authorCode, input.newPhone, phoneObser, authorCodeObser)
            .map { data -> (String, String, Bool) in
                return (data.0, data.1, data.2 && data.3)
        }

        tap.getAuthorCode.drive(onNext: { [unowned self] in self.getEmailCode() })
            .disposed(by: disposeBag)
        
        tap.submit.withLatestFrom(validate)
            .filter({ data -> Bool in
                if data.2 == false {
                    NoticesCenter.alert(title: "提示", message: "信息填写不正确！")
                }
                return data.2
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] data in
                self.postRequest(phone: data.1, emailCode: data.0)
            })
            .disposed(by: disposeBag)
    }
    
    private func postRequest(phone: String, emailCode: String) {
        CARProvider.rx.request(.setPhone(phone: phone, emailCode: emailCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message, {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func getEmailCode() {
        CARProvider.rx.request(.setEmailCodeForMe())
            .mapResponse()
            .subscribe(onSuccess: { model in
                if model.error == 0 {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }else {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
}

//MARK:
//MARK: 修改密保邮箱
class SetEmailViewModel: BaseViewModel {
    
    var emailObser: Driver<Bool>!
    var authorCodeObser: Driver<Bool>!

    init(input:(authorCode: Driver<String>, newEmail: Driver<String>),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        emailObser = input.newEmail.map{ ValidateNum.email($0).isRight }
        authorCodeObser = input.authorCode.map{ $0.count > 0 }
        
        // 判断是否可以提交修的请求
        let validate = Driver.combineLatest(input.authorCode, input.newEmail, emailObser, authorCodeObser)
            .map { data -> (String, String, Bool) in
                return (data.0, data.1, data.2 && data.3)
        }
        
        tap.getAuthorCode.drive(onNext: { [unowned self] in self.getSmsCode() })
            .disposed(by: disposeBag)
        
        tap.submit.withLatestFrom(validate)
            .filter({ data -> Bool in
                if data.2 == false {
                    NoticesCenter.alert(title: "提示", message: "信息填写不正确！")
                }
                return data.2
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] data in
                self.postRequest(email: data.1, smsCode: data.0)
            })
            .disposed(by: disposeBag)
    }
    
    private func postRequest(email: String, smsCode: String) {
        CARProvider.rx.request(.setEmail(email: email, smsCode: smsCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message, {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }

    private func getSmsCode() {
        CARProvider.rx.request(.sendSmsCodeForMe())
            .mapResponse()
            .subscribe(onSuccess: { model in
                if model.error == 0 {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }else {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}

//MARK:
//MARK: 修改收款支付宝账号
class SetAlipayViewModel: BaseViewModel {
    
    var alipayObser: Driver<Bool>!
    var authorCodeObser: Driver<Bool>!

    init(input:(authorCode: Driver<String>, newAlipay: Driver<String>),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        alipayObser = input.newAlipay.map{ (ValidateNum.phoneNum($0).isRight || ValidateNum.email($0).isRight) }
        authorCodeObser = input.authorCode.map{ $0.count > 0 }
        
        // 判断是否可以提交修的请求
        let validate = Driver.combineLatest(input.authorCode, input.newAlipay, alipayObser, authorCodeObser)
            .map { data -> (String, String, Bool) in
                return (data.0, data.1, data.2 && data.3)
        }
        
        tap.getAuthorCode.drive(onNext: { [unowned self] in self.getSmsCode() })
            .disposed(by: disposeBag)
        
        tap.submit.withLatestFrom(validate)
            .filter({ data -> Bool in
                if data.2 == false {
                    NoticesCenter.alert(title: "提示", message: "信息填写不正确！")
                }
                return data.2
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] data in
                self.postRequest(account: data.1, smsCode: data.0)
            })
            .disposed(by: disposeBag)
    }

    private func postRequest(account: String, smsCode: String) {
        CARProvider.rx.request(.setAlipay(account: account, smsCode: smsCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message, {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }

    private func getSmsCode() {
        CARProvider.rx.request(.sendSmsCodeForMe())
            .mapResponse()
            .subscribe(onSuccess: { model in
                if model.error == 0 {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }else {
                    NoticesCenter.alert(title: "提示", message: model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
