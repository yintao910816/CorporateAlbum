//
//  CAMySiteLogViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

class CAMySiteLogViewModel: RefreshVM<CAMySiteLogInfoModel> {
    
    private var siteModel: CAMySiteModel!
    
    init(siteModel: CAMySiteModel) {
        super.init()
        
        self.siteModel = siteModel
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.mySiteListLog(siteName: siteModel.SiteName, skip: pageModel.currentPage, limit: pageModel.pageSize))
            .map(models: CAMySiteLogInfoModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
