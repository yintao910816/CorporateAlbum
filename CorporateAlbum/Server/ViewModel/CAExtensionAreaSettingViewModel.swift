//
//  CAExtensionAreaSettingViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift

class CAExtensionAreaSettingViewModel: BaseViewModel {
    
    private var siteModel: CAMySiteModel!
    
    public let regionDataource = Variable([CARegionInfoModel]())
    
    init(siteModel: CAMySiteModel, listData: [CARegionInfoModel]) {
        super.init()
        
        self.siteModel = siteModel
        
        reloadSubject.subscribe(onNext: { [unowned self] _ in
            self.regionDataource.value = listData
        })
        .disposed(by: disposeBag)
    }
}
