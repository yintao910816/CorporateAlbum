//
//  CAOrderListItemsViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAOrderListItemsViewModel: RefreshVM<CAOrderItemInfoModel> {
    
    private var orderModel: CAOrderInfoModel!
    
    init(orderModel: CAOrderInfoModel) {
        super.init()
        self.orderModel = orderModel
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestData(true)
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
}
