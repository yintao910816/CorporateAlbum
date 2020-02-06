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
    public let siteInfoObser = Variable(CAMySiteModel())

    init(input: CAMySiteModel) {
        super.init()
        
        siteModel = input
        
        NotificationCenter.default.rx.notification(NotificationName.User.extensionRegionChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestRegionList()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.siteInfoChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestSiteInfo()
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestRegionList()
            self?.siteInfoObser.value = input
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRegionList() {
        CARProvider.rx.request(.listRegion(siteName: siteModel.SiteName))
            .map(models: CARegionInfoModel.self)
            .subscribe(onSuccess: { data in
                self.regionDataource.value = data
                
                NotificationCenter.default.post(name: NotificationName.User.reloadExtensionRegionView, object: data)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func requestSiteInfo() {
        CARProvider.rx.request(.getMySite(siteName: siteModel.SiteName))
            .map(model: CAMySiteModel.self)
            .subscribe(onSuccess: { [weak self] model in
                self?.siteModel = model
                self?.siteInfoObser.value = model
                NotificationCenter.default.post(name: NotificationName.User.reloadSiteInfoView, object: model)
            }) {
                PrintLog($0)
        }
        .disposed(by: disposeBag)
    }
    
    public func prepareParams(type: CASiteSettingType) ->[String: Any]? {
        switch type {
        case .extensionAreaSetting:
            return ["list":regionDataource.value, "site": siteModel]
        case .editManagePwd:
            return ["model": siteModel]
        default:
            return nil
        }
    }
}
