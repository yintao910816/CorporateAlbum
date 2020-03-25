//
//  CAReFundsViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/3/25.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CAReFundsViewModel: BaseViewModel {
    
    public let drawInfoObser = Variable(CAWithdrawInfoModel())
    
    init(reRundsDriver: Driver<String>, submitDriver: Driver<Void>) {
        super.init()
        
        submitDriver.withLatestFrom(reRundsDriver)
            .map { Double($0) ?? 0.0 }
            .filter { [unowned self] amount -> Bool in
                if amount < self.drawInfoObser.value.MinWithdwaw {
                    NoticesCenter.alert(message: "提现金额小于最小提现金额")
                    return false
                }
                return true
        }
        ._doNext(forNotice: hud)
        .drive(onNext: { [unowned self] in
            self.requestWithDrawSubmit(amount: $0)
        })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestWithdrawInfo()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestWithdrawInfo() {
        CARProvider.rx.request(.withdraw)
            .map(model: CAWithdrawInfoModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.drawInfoObser.value = $0
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
    
    private func requestWithDrawSubmit(amount: Double) {
        CARProvider.rx.request(.withdrawSubmit(amount: amount))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] in
                if $0.error == 0 {
                    self?.hud.successHidden($0.message, {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
