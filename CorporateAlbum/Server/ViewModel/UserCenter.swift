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
        CARProvider.rx.request(.getUserInfo)
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
    
    private var nickName: String = ""
    private var userinfoModel: UserInfoModel!
    
    init(nickName: Driver<String>, submit: Driver<Void>, userInfoModel: UserInfoModel) {
        super.init()
        
        self.userinfoModel = userInfoModel
        
        nickName.drive(onNext: { [weak self] in self?.nickName = $0 })
            .disposed(by: disposeBag)
        
        submit
            .filter({ [unowned self] _ -> Bool in
                if self.nickName.count >= 3 && self.nickName.count <= 16 {
                    return true
                }
                NoticesCenter.alert(message: "请输入3-16个字符的昵称")
                return false
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in self.postRequest() })
            .disposed(by: disposeBag)
                
    }

    private func postRequest() {
        CARProvider.rx.request(.setNickName(nickName: nickName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                guard let strongSelf = self else { return }
                if model.error == 0 {
                    UserInfoModel.update(nickName: strongSelf.nickName)
                    strongSelf.hud.successHidden(model.message, {
                        strongSelf.popSubject.onNext(true)
                    })
                }else {
                    strongSelf.hud.failureHidden(model.message)
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

    private var timer: CountdownTimer!
    private var userInfo: UserInfoModel!
    
    public let enabelSubject = Variable(false)
    public let codeEnableSubject = Variable(true)
    public let secondsSubject = PublishSubject<String>()

    init(input:(phone: Driver<String>, code: Driver<String>, userInfo: UserInfoModel),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        self.userInfo = input.userInfo
        
        let phoneObser = input.phone.map{ ValidateNum.phoneNum($0).isRight }
        let authorCodeObser = input.code.map{ $0.count > 0 }
        
        // 判断是否可以提交修的请求
        let validate = Driver.combineLatest(input.phone, input.code, phoneObser, authorCodeObser)
            .map { data -> (String, String, Bool) in
                PrintLog("手机号码: \(data.0) 验证码: \(data.1) - 手机号通过：\(data.2) - 验证码通过：\(data.3)")
                return (data.0, data.1, data.2 && data.3)
        }
        .do(onNext: { [unowned self] in
            PrintLog("可以提交：\($0.2)")
            self.enabelSubject.value = $0.2
        })
        
        let enableCode = input.phone
            .map { data -> (String, Bool) in
                return (data, data.count > 0)
        }
        
        tap.getAuthorCode.withLatestFrom(enableCode)
            .filter { data -> Bool in
                if data.1 { return true }
                
                NoticesCenter.alert(message: "请输入正确的手机号码")
                return false
            }
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in self.getAuthorCodeRequest(phone: $0.0) })
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
        
        prepareTimer()
    }
    
    private func prepareTimer() {
        timer = CountdownTimer.init(totleCount: 60)

        timer.showText.asDriver()
            .skip(1)
            .drive(onNext: { [weak self] second in
                if second == 0 {
                    self?.codeEnableSubject.value = true
                    self?.secondsSubject.onNext("获取验证码")
                }else {
                    self?.secondsSubject.onNext("\(second)s")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func postRequest(phone: String, emailCode: String) {
        CARProvider.rx.request(.setPhone(phone: phone, smsCode: emailCode))
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
    
    private func getAuthorCodeRequest(phone: String) {
        timer.timerStar()
        codeEnableSubject.value = false

        CARProvider.rx.request(.smsSendCode(phone: phone))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message)
                }else {
                    self?.codeEnableSubject.value = true
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.codeEnableSubject.value = true
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
        CARProvider.rx.request(.sendSmsCodeForMe)
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
        CARProvider.rx.request(.sendSmsCodeForMe)
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
