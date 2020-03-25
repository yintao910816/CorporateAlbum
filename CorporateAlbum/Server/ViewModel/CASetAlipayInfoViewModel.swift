//
//  CASetAlipayInfoViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CASetAlipayInfoViewModel: BaseViewModel {
    
    private var timer: CountdownTimer!
    
    public let userInfoObser = Variable(UserInfoModel())
    public let codeEnableSubject = Variable(true)
    public let secondsSubject = PublishSubject<String>()

    public var idCardImage: UIImage?

    init(input:(code: Driver<String>, alipayAccount: Driver<String>, idCard: Driver<String>, alipayName: Driver<String>),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        UserInfoModel.loginUser { [weak self] in
            if let user = $0 {
                self?.userInfoObser.value = user
            }
        }
                
        tap.getAuthorCode
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in
                self?.getAuthorCodeRequest()
            })
            .disposed(by: disposeBag)
        
        let submitSignal = Driver.combineLatest(input.code, input.alipayAccount, input.idCard, input.alipayName)
            .map{ ($0, $1, $2, $3) }
        tap.submit.withLatestFrom(submitSignal)
            .filter { [unowned self] data -> Bool in
                if data.0.count == 0 {
                    NoticesCenter.alert(message: "请输入验证码")
                    return false
                }
                if data.1.count == 0 {
                    NoticesCenter.alert(message: "请输入支付宝账号")
                    return false
                }
                if data.2.count == 0 {
                    NoticesCenter.alert(message: "请输入身份证号码")
                    return false
                }
                if data.3.count == 0 {
                    NoticesCenter.alert(message: "请输入支付宝实名")
                    return false
                }
                if self.idCardImage == nil {
                    NoticesCenter.alert(message: "请上传身份证照片")
                    return false
                }
                return true
        }
        ._doNext(forNotice: hud)
        .drive(onNext: { [weak self] in
            self?.setAlipayRequest(data: $0)
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

    private func getAuthorCodeRequest() {
        timer.timerStar()
        codeEnableSubject.value = false

        CARProvider.rx.request(.sendSmsCodeForMe)
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

    private func setAlipayRequest(data: (String, String, String, String)) {
        CARProvider.rx.request(.setAlipay(smsCode: data.0, account: data.1, accountName: data.3, cardNo: data.2, idCardImage: idCardImage!))
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
}
