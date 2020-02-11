//
//  CAOrderListItemsViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CAOrderListItemsViewModel: RefreshVM<CAOrderItemInfoModel> {
    
    private var orderModel: CAOrderInfoModel!
    
    init(orderModel: CAOrderInfoModel, submit: Driver<Void>) {
        super.init()
        self.orderModel = orderModel
        
        submit.map{ [unowned self] in return self.orderModel.Id }
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                self.requestPreparePayOrder(orderId: $0)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestData(true)
        })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Pay.alipaySuccess, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.hud.successHidden("支付成功", {
                    self?.popSubject.onNext(true)
                })
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Pay.alipayFailure, object: nil)
            .subscribe(onNext: { [weak self] no in
                self?.hud.noticeHidden()
                NoticesCenter.alert(message: (no.object as? String) ?? "支付失败")
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.orderListItems(orderId: orderModel.Id))
            .map(models: CAOrderItemInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func requestPreparePayOrder(orderId: String) {
        CARProvider.rx.request(.orderPay(orderId: orderId))
            .map(model: CAPaymentInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()
                AlipaySDK.defaultService()?.payOrder(data.Body, fromScheme: appScheme, callback: { result in

                })
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
