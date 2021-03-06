//
//  SiteInfoViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class SiteAlbumBookViewModel: RefreshVM<AlbumBookModel>, VMNavigation {
    
    public let collectePublic = PublishSubject<AlbumBookModel>()
    public let sharePublic = PublishSubject<AlbumBookModel>()

    var navTitleObser = Variable("")

    private var siteName: String!
    
    init(siteName: String) {
        super.init()
        
        self.siteName = siteName
        
        collectePublic
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.collectBook(model: $0) })
            .disposed(by: disposeBag)
                
        sharePublic
            .subscribe(onNext: { [unowned self] in
                SiteAlbumBookViewModel.sbPush("Main", "shareAlbumCtrlID", parameters: ["model": $0])
            })
            .disposed(by: disposeBag)
            
        
        NotificationCenter.default.rx.notification(NotificationName.Album.SiteAlbumRewardChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestSiteInfo()
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.bookList(search: siteName, skip: pageModel.currentPage, limit: pageModel.pageSize, category: 0))
            .map(models: AlbumBookModel.self)
            .subscribe(onSuccess: { [weak self] datas in
                self?.updateRefresh(refresh, datas)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func requestSiteInfo() {
        CARProvider.rx.request(.siteGet(siteName: siteName))
            .map(model: CASiteInfoModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.navTitleObser.value = $0.SiteTitle
            })
            .disposed(by: disposeBag)
    }
    
    private func collectBook(model: AlbumBookModel) {
        CARProvider.rx.request(.addBook(bookId: model.Id))
            .mapResponse()
            .subscribe(onSuccess: { [unowned self] model in
                if model.error == 0 {
                    self.hud.successHidden("操作成功！")
                }else {
                    self.hud.failureHidden(model.message)
                }
            }) { [unowned self] error in
                self.hud.failureHidden(self.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }

}
