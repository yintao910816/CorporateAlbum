//
//  AlbumViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumViewModel: RefreshVM<AlbumBookModel>, VMNavigation {
    
    // 0:全部,1:推荐,2:收藏
    private var dataType: Int = 0
    
    public let collectePublic = PublishSubject<AlbumBookModel>()
    public let menuChangeSubject = PublishSubject<Int>()
    public let beginSearchSubject = PublishSubject<Void>()

    public let searchTextObser = Variable("")
    
    override init() {
        super.init()
        
        collectePublic
            .filter({ [unowned self] _ -> Bool in
                if CACoreLogic.isUserLogin() == true {
                    return true
                }
                self.hud.failureHidden("您还没有登录~")
                return false
            })
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.collectBook(model: $0) })
            .disposed(by: disposeBag)
        
        menuChangeSubject
            .subscribe(onNext: { [unowned self] in
                self.dataType = $0
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        beginSearchSubject
            .subscribe(onNext: { [unowned self] in
                self.requestData(true)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NotificationName.Album.HomeAlbumRewardChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [unowned self] _ in
                self.loadCacheDatas()
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.bookList(search: searchTextObser.value,
                                         skip: pageModel.skip,
                                         limit: pageModel.pageSize,
                                         category: dataType))
            .map(models: AlbumBookModel.self)
            .subscribe(onSuccess: { [unowned self] datas in
                self.updateRefresh(refresh, datas, datas.count)
                AlbumBookModel.insert(datas: datas)
            }) { [unowned self] error in
                self.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func collectBook(model: AlbumBookModel) {
        CARProvider.rx.request(.addBook(siteName: model.SiteName, bookId: model.Id))
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
    
    private func loadCacheDatas() {
        Observable<[AlbumBookModel]>.selectedDB(type: AlbumBookModel.self, tbName: AlbumBookTB)
            .subscribe(onNext: { [weak self] in
                self?.datasource.value = $0
            })
            .disposed(by: disposeBag)
    }
}
