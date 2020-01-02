//
//  BillViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class BillViewModel: RefreshVM<BillInfoModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.bill(search: "", skip: pageModel.skip, limit: pageModel.pageSize))
            .map(models: BillInfoModel.self)
            .subscribe(onSuccess: { models in
                self.updateRefresh(refresh, models, models.count)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
