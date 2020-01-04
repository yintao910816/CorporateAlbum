//
//  CorporateViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CorporateViewModel: RefreshVM<SiteInfoModel>, VMNavigation {
    
    // 0 - 全部，1 - 收藏
    let dataTypeObser = Variable(0)

    var collectePublic = PublishSubject<SiteInfoModel>()
    private var searchText: String = ""
    
    init(searchTextObser: Driver<String>) {
        super.init()
    
        searchTextObser.drive(onNext: { [unowned self] in
            self.searchText = $0
        })
            .disposed(by: disposeBag)
        
        collectePublic
            .filter({ [unowned self] _ -> Bool in
                if CACoreLogic.isUserLogin() == true {
                    return true
                }
                self.hud.failureHidden("您还没有登录~")
                return false
            })
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.collectSite(model: $0) })
            .disposed(by: disposeBag)

        itemSelected.subscribe(onNext: { [unowned self] indexPath in
            let model = self.datasource.value[indexPath.row]
           CorporateViewModel.sbPush("Main", "siteAlbumCtrlID",
                                     bundle: Bundle.main,
                                     parameters: ["siteName": model.SiteName, "title": model.SiteTitle])
        })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Album.SiteRewardChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        if dataTypeObser.value == 0 {
            let request = CARProvider.rx.request(.site(search: searchText, skip: pageModel.currentPage, limit: pageModel.pageSize))
                .map(models: SiteInfoModel.self)
            
            Observable<SiteInfoModel>.selectedDB(type: SiteInfoModel.self, tbName: SiteInfoTB)
                .concat(request.asObservable())
                .subscribe(onNext: { [unowned self] datas in
                    self.updateRefresh(refresh, datas)
                    SiteInfoModel.insert(datas: datas)
                }, onError: { [unowned self] error in
                    self.revertCurrentPageAndRefreshStatus()
                    self.hud.failureHidden(self.errorMessage(error))
                })
                .disposed(by: disposeBag)
        }else {
            CARProvider.rx.request(.favoriteSite(search: searchText, skip: pageModel.currentPage, limit: pageModel.pageSize))
                .map(models: SiteInfoModel.self)
                .subscribe(onSuccess: { [weak self] models in
                    self?.updateRefresh(refresh, models)
                }) { [weak self] error in
                    self?.revertCurrentPageAndRefreshStatus()
                    self?.hud.failureHidden(self?.errorMessage(error))
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func collectSite(model: SiteInfoModel) {
        CARProvider.rx.request(.addSite(siteName: model.SiteName, siteId: model.Id))
            .mapResponse()
            .subscribe(onSuccess: { [unowned self] model in
                if model.error == 0 {
                    self.hud.successHidden("收藏成功！")
                }else {
                    self.hud.failureHidden(model.message)
                }
            }) { [unowned self] error in
                self.hud.failureHidden(self.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
