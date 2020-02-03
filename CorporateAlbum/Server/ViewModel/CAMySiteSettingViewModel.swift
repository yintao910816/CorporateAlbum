//
//  CAMySiteSettingViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift

class CAMySiteSettingViewModel: BaseViewModel {
    
    private var siteModel: CAMySiteModel!
    
    public let regionDataource = Variable([CARegionInfoModel]())
    
    init(input: CAMySiteModel) {
        super.init()
        
        siteModel = input
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestRegionList()
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRegionList() {
        CARProvider.rx.request(.listRegion(siteName: siteModel.SiteName))
            .map(models: CARegionInfoModel.self)
            .subscribe(onSuccess: { data in
                self.regionDataource.value = data
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    public func prepareParams(type: CASiteSettingType) ->[String: Any]? {
        switch type {
        case .extensionAreaSetting:
            return ["list":regionDataource.value, "site": siteModel]
        default:
            return nil
        }
    }
}
