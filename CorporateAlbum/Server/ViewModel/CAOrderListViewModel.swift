//
//  CAOrderListViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAOrderListViewModel: RefreshVM<CAOrderInfoModel> {
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestData(true)
        })
        .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.orderList(skip: pageModel.currentPage, limit: pageModel.pageSize))
            .map(models: CAOrderInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
