//
//  MyAlbumViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/31.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class MyAlbumViewModel: RefreshVM<CAMySiteModel> {
    
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
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestData(true)
        })
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.reloadSiteInfoView, object: nil)
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                
                guard let model = $0.object as? CAMySiteModel else { return }
                strongSelf.datasource.value = strongSelf.datasource.value.map { $0.SiteName == model.SiteName ? model: $0 }
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.mySite(skip: pageModel.currentPage, limit: pageModel.pageSize))
            .map(models: CAMySiteModel.self)
            .subscribe(onSuccess: { models in
                self.updateRefresh(refresh, models)
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
//                    model.AwardState = model.AwardState == 0 ? 1 : 0
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
//                    model.SiteState = model.SiteState == 0 ? 1 : 0
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
