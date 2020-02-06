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
    public let deleteRegionSubject = PublishSubject<CARegionInfoModel>()
    
    init(siteModel: CAMySiteModel, listData: [CARegionInfoModel]) {
        super.init()
        
        self.siteModel = siteModel
        
        reloadSubject.subscribe(onNext: { [unowned self] _ in
            self.regionDataource.value = listData
        })
        .disposed(by: disposeBag)
        
        deleteRegionSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestRemoveRegion(model: $0)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.reloadExtensionRegionView, object: nil)
            .subscribe(onNext: { [weak self] in
                guard let datas = $0.object as? [CARegionInfoModel] else { return }
                
                self?.regionDataource.value = datas
            })
            .disposed(by: disposeBag)
    }
    
    private func requestRemoveRegion(model: CARegionInfoModel) {
        CARProvider.rx.request(.removeRegion(siteName: siteModel.SiteName, regionCode: model.Code, regionText: model.Title))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                guard let strongSelf = self else { return }
                if ret.error == 0 {
                    strongSelf.regionDataource.value = strongSelf.regionDataource.value.filter{ $0.Code != model.Code }
                    NotificationCenter.default.post(name: NotificationName.User.extensionRegionChanged, object: nil)
                    strongSelf.hud.noticeHidden()
                }else {
                    strongSelf.hud.failureHidden(ret.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
