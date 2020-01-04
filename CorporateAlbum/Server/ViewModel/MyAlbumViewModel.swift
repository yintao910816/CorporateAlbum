//
//  MyAlbumViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/31.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class MyAlbumViewModel: RefreshVM<SiteInfoModel> {
    
    var enableAwardSubject = PublishSubject<SiteInfoModel>()
    var siteStateSubject = PublishSubject<SiteInfoModel>()
    var resetAwardSubject = PublishSubject<SiteInfoModel>()

    override init() {
        super.init()
        
        enableAwardSubject.asObserver()
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.awardRequest(model: $0) })
            .disposed(by: disposeBag)
        
        siteStateSubject.asObserver()
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.siteStateRequest(model: $0) })
            .disposed(by: disposeBag)

        resetAwardSubject.asObserver()
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.resetAwardRequest(model: $0) })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.mySite(skip: pageModel.skip, limit: pageModel.pageSize))
            .map(models: SiteInfoModel.self)
            .subscribe(onSuccess: { models in
                self.updateRefresh(refresh, models, models.count)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func awardRequest(model: SiteInfoModel) {
        let data = datasource.value
        CARProvider.rx.request(.siteEnableAward(siteName: model.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    model.AwardState = model.AwardState == 0 ? 1 : 0
                    self?.hud.successHidden("操作成功！", {
                        self?.datasource.value = data
                    })
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func siteStateRequest(model: SiteInfoModel) {
        let data = datasource.value
        CARProvider.rx.request(.siteOnline(siteName: model.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    model.SiteState = model.SiteState == 0 ? 1 : 0
                    self?.hud.successHidden("操作成功！", {
                        self?.datasource.value = data
                    })
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }

    private func resetAwardRequest(model: SiteInfoModel) {
        CARProvider.rx.request(.siteResetAward(siteName: model.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    self?.hud.successHidden("操作成功！")
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }

}
