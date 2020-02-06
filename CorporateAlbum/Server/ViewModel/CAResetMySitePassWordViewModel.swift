//
//  CAResetMySitePassWordViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/6.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CAResetMySitePassWordViewModel: BaseViewModel {
    
    private var siteModel: CAMySiteModel!
        
    public var submitEnable: Driver<Bool>!
    
    init(input:(siteModel: CAMySiteModel, passDriver: Driver<String>),
         submit: Driver<Void>) {
        super.init()
        
        self.siteModel = input.siteModel
               
        submitEnable = input.passDriver.map { [unowned self] in $0 != self.siteModel.ManagePassword }
        
        submit.withLatestFrom(input.passDriver)
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                self.requestResetPass(pass: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestResetPass(pass: String) {
        CARProvider.rx.request(.setManagePassword(siteName: siteModel.SiteName, manageName: siteModel.ManageUserName, managePassword: pass))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                guard let strongSelf = self else { return }
                if ret.error == 0 {
                    NotificationCenter.default.post(name: NotificationName.User.siteInfoChanged, object: strongSelf.siteModel)
                    strongSelf.hud.successHidden("修改成功", {
                        strongSelf.popSubject.onNext(true)
                    })
                }else {
                    strongSelf.hud.failureHidden(ret.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
