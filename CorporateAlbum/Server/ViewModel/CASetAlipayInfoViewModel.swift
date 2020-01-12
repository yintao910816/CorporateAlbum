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
    private var userInfo: UserInfoModel!

    public let enabelSubject = Variable(false)
    public let codeEnableSubject = Variable(true)
    public let secondsSubject = PublishSubject<String>()

    init(input:(code: Driver<String>, alipayAccount: Driver<String>, idCard: Driver<String>, userInfo: UserInfoModel),
         tap:(getAuthorCode: Driver<Void>, submit: Driver<Void>)) {
        super.init()
        
        self.userInfo = input.userInfo
        
//        let phoneObser = input.phone.map{ ValidateNum.phoneNum($0).isRight }
//        let authorCodeObser = input.code.map{ $0.count > 0 }
//        
//        // 判断是否可以提交修的请求
//        let validate = Driver.combineLatest(input.phone, input.code, phoneObser, authorCodeObser)
//            .map { data -> (String, String, Bool) in
//                PrintLog("手机号码: \(data.0) 验证码: \(data.1) - 手机号通过：\(data.2) - 验证码通过：\(data.3)")
//                return (data.0, data.1, data.2 && data.3)
//        }
//        .do(onNext: { [unowned self] in
//            PrintLog("可以提交：\($0.2)")
//            self.enabelSubject.value = $0.2
//        })
//        
//        let enableCode = input.phone
//            .map { data -> (String, Bool) in
//                return (data, data.count > 0)
//        }
//        
//        tap.getAuthorCode.withLatestFrom(enableCode)
//            .filter { data -> Bool in
//                if data.1 { return true }
//                
//                NoticesCenter.alert(message: "请输入正确的手机号码")
//                return false
//            }
//            ._doNext(forNotice: hud)
//            .drive(onNext: { [unowned self] in self.getAuthorCodeRequest(phone: $0.0) })
//            .disposed(by: disposeBag)
//        
//        tap.submit.withLatestFrom(validate)
//            .filter({ data -> Bool in
//                if data.2 == false {
//                    NoticesCenter.alert(title: "提示", message: "信息填写不正确！")
//                }
//                return data.2
//            })
//            ._doNext(forNotice: hud)
//            .drive(onNext: { [unowned self] data in
//                self.postRequest(phone: data.1, emailCode: data.0)
//            })
//            .disposed(by: disposeBag)
        
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
