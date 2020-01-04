//
//  LoginServer.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/26.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//MARK:
//MARK: 注册
class RegisterViewModel: BaseViewModel, VMNavigation {
    
    private var authorPhone: String = ""
    public var phoneObser: Driver<Bool>!
    public var nickNameObser: Driver<Bool>!
    public var passObser: Driver<Bool>!
    public var repassObser: Driver<Bool>!
    public var authorCodeObser: Driver<Bool>!
    public var agreeObser = Variable(true)

    public let codeSendComplenmentSubject = PublishSubject<Bool>()
    public let agreementDriverSubject = PublishSubject<Void>()
    public let codeEnable = Variable(true)
    public var submitEnableObser: Driver<Bool>!

    init(input:(phone: Driver<String>, nickName: Driver<String>, pass: Driver<String>, repass: Driver<String>, authorCode: Driver<String>),
         tap:(authorCode: Driver<Void>, register: Driver<Void>)) {
        super.init()
        
        agreementDriverSubject
            .subscribe(onNext: {
                RegisterViewModel.push(WebViewController.self, ["url": APIAssistance.registerAggrement, "title": "注册协议"])
            })
            .disposed(by: disposeBag)
        
        tap.authorCode.withLatestFrom(input.phone)
            .filter({ phoneNum -> Bool in
                if ValidateNum.phoneNum(phoneNum).isRight == true { return true }
                NoticesCenter.alert(title: "提示", message: "请输入正确的手机号码", okTitle: "知道了")
                return false
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] phone in
                self.getAuthorCodeRequest(phone: phone)
            })
            .disposed(by: disposeBag)
        
        phoneObser = input.phone.map{
            if (self.authorPhone.count > 0 && $0 != self.authorPhone) || ValidateNum.phoneNum($0).isRight == false { return false }
            return true
        }
        
        nickNameObser = input.nickName.map{
            return ValidateNum.string($0, min: 3, max: 16).isRight && ValidateNum.specialCharacters($0).isRight
        }
        
        passObser = input.pass.map {
            if ValidateNum.string($0, min: 3, max: 16).isRight == false { return false }
            return true
        }
        
        repassObser = Driver.combineLatest(input.pass, input.repass).map {
            if $1.count == 0 || ($1.count > 0 && $1 != $0) { return false }
            return true
        }
        
        authorCodeObser = input.authorCode.map { return $0.count > 0 }
        
        submitEnableObser = Driver.combineLatest(phoneObser, nickNameObser, passObser, repassObser, authorCodeObser).map {
            return ($0 && $1 && $2 && $3 && $4)
        }
        
        let validate = Driver.combineLatest(input.phone, input.nickName, input.pass, input.repass, input.authorCode, submitEnableObser){ ($0, $1, $2, $3, $4, $5) }
        
        tap.register.withLatestFrom(validate)
            .filter({ [unowned self] data -> Bool in
                if !self.agreeObser.value {
                    NoticesCenter.alert(title: "提示", message: "请先同意注册协议")
                    return false
                }
                if data.5 == false { NoticesCenter.alert(title: "提示", message: "请填写正确的信息！") }
                return data.5
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone, nickName, pass, repass, authorCode, _) in
                self.registerRequest(phone: phone, nickName: nickName, pass: pass, authorCode: authorCode)
            })
            .disposed(by: disposeBag)
        
    }

    // 注册
    private func registerRequest(phone: String, nickName: String, pass: String, authorCode: String) {
        CARProvider.rx.request(.register(phone: phone, nickName: nickName, password: pass, smscode: authorCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    userDefault.userType = .platform
                    self?.hud.successHidden("注册成功，请登录", {
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
    
    // 获取短信验证码
    private func getAuthorCodeRequest(phone: String) {
        codeEnable.value = false

        CARProvider.rx.request(.smsSendCode(phone: phone))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message)
                    self?.codeSendComplenmentSubject.onNext(true)
                }else {
                    self?.hud.failureHidden(model.message)
                    self?.codeSendComplenmentSubject.onNext(false)
                }
                self?.authorPhone = phone
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
                self?.codeSendComplenmentSubject.onNext(false)
                self?.codeEnable.value = true
            }
            .disposed(by: disposeBag)
    }
    
}

//MARK:
//MARK: 登录
class LoginViewModel: BaseViewModel {
    
    var phoneObser: Driver<Bool>!
    var passObser: Driver<Bool>!

    public var loginSubmitDriver: Driver<Bool>!
    
    init(input:(phone: Driver<String>, pass: Driver<String>),
         loginDriver: Driver<Void>) {
        super.init()
    
        phoneObser = input.phone.map{ ValidateNum.phoneNum($0).isRight }
        passObser = input.pass.map{ ValidateNum.string($0, min: 3, max: 16).isRight }
        
        loginSubmitDriver = Driver.combineLatest(phoneObser, passObser) { $0 && $1 }
        let validate = Driver.combineLatest(input.phone, input.pass, loginSubmitDriver)
            
        loginDriver.withLatestFrom(validate)
            .filter { (_, _, ret) -> Bool in
                if ret == false { NoticesCenter.alert(title: "提示", message: "请输入正确的账号和密码！") }
                return ret
            }._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone, pass, _) in
                self.postLoginRequest(phone, pass)
            })
            .disposed(by: disposeBag)
    }
    
    private func postLoginRequest(_ phone: String, _ pass: String) {
        CARProvider.rx.request(.login(phone: phone, pass: pass))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    userDefault.userType = .platform
                    self?.popSubject.onNext(true)
                }else {
                    self?.hud.failureHidden(model.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}

//MARK:
//MARK: 找回密码
class ResetPassViewModel: BaseViewModel {
    
    private var authorPhone: String = ""
    
    public var phoneObser: Driver<Bool>!
    public var passObser: Driver<Bool>!
    public var repassObser: Driver<Bool>!
    public var authorCodeObser: Driver<Bool>!

    public let codeEnable = Variable(true)
    public var submitEnableObser: Driver<Bool>!
    public let codeSendComplenmentSubject = PublishSubject<Bool>()

    init(input:(phone: Driver<String>, pass: Driver<String>, repass: Driver<String>, authorCode: Driver<String>),
         tap:(authorCode: Driver<Void>, register: Driver<Void>)) {
        super.init()
        
        tap.authorCode.withLatestFrom(input.phone)
            .filter({ phoneNum -> Bool in
                if ValidateNum.phoneNum(phoneNum).isRight == true { return true }
                NoticesCenter.alert(title: "提示", message: "请输入正确的手机号码", okTitle: "知道了")
                return false
            }).drive(onNext: { [unowned self] phone in
                self.getAuthorCodeRequest(phone: phone)
            })
            .disposed(by: disposeBag)
        
        phoneObser = input.phone.map{
            if (self.authorPhone.count > 0 && $0 != self.authorPhone) || ValidateNum.phoneNum($0).isRight == false { return false }
            return true
        }
        
        passObser = input.pass.map {
            if ValidateNum.string($0, min: 3, max: 16).isRight == false { return false }
            return true
        }
        
        repassObser = Driver.combineLatest(input.pass, input.repass).map {
            if $1.count == 0 || ($1.count > 0 && $1 != $0) { return false }
            return true
        }
        
        authorCodeObser = input.authorCode.map { return $0.count > 0 }
        
        submitEnableObser = Driver.combineLatest(phoneObser, passObser, repassObser, authorCodeObser).map {
            return ($0 && $1 && $2 && $3)
        }
        
        let validate = Driver.combineLatest(input.phone, input.pass, input.repass, input.authorCode, submitEnableObser){ ($0, $1, $2, $3, $4) }
        
        tap.register.withLatestFrom(validate)
            .filter({ data -> Bool in
                if data.4 == false { NoticesCenter.alert(title: "提示", message: "请填写正确的信息！") }
                return data.4
            })
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] (phone, pass, repass, authorCode, _) in
                self.resetPass(phone: phone, pass: pass, smsCode: authorCode)
            })
            .disposed(by: disposeBag)

    }
    
    // 修改密码
    private func resetPass(phone: String, pass: String, smsCode: String) {
        CARProvider.rx.request(.setPassword(phone: phone, password: pass, smscode: smsCode))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden("密码修改成功，请登录！", {
                        self?.popSubject.onNext(true)
                    })
                }else { self?.hud.failureHidden(model.message) }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    // 获取短信验证码
    private func getAuthorCodeRequest(phone: String) {
        codeEnable.value = false

        CARProvider.rx.request(.smsSendCode(phone: phone))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    self?.hud.successHidden(model.message)
                    self?.codeSendComplenmentSubject.onNext(true)
                }else {
                    self?.hud.failureHidden(model.message)
                    self?.codeSendComplenmentSubject.onNext(false)
                }
                self?.authorPhone = phone
            }) { [weak self] error in
                self?.codeEnable.value = true
                self?.hud.failureHidden(self?.errorMessage(error))
                self?.codeSendComplenmentSubject.onNext(false)
            }
            .disposed(by: disposeBag)
    }
    
}
