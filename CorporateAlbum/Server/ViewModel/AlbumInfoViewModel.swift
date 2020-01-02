//
//  AlbumInfoViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class AlbumInfoViewModel: BaseViewModel {
    
    private var bookId: String!
    private var bookInfo: AlbumBookModel!
    
    // (collectionView数据源，刷新col时是否重新设置pageVC)
    var colDatasourceObser = Variable(([AlbumPageModel](), true))
    
    var pageSendAward = PublishSubject<AlbumPageModel>()
    
    var dropCoinObser = PublishSubject<(Int, AlbumPageModel)>()
    
    init(bookId: String) {
        super.init()
        
        self.bookId = bookId
        
        pageSendAward
            .filter{ _ in CACoreLogic.isUserLogin() }
            .subscribe(onNext: { [weak self] model in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self?.postAward(pageModel: model)
                })
        })
        .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [unowned self] _ in
            self.loadBookInfoRequest()
        })
            .disposed(by: disposeBag)
    }
    
    private func loadBookInfoRequest() {
        hud.noticeLoading()
        
        CARProvider.rx.request(.getBookInfo(id: bookId))
            .map(model: AlbumBookModel.self)
            .subscribe(onSuccess: { [weak self] book in
                self?.bookInfo = book
                self?.loadBookPages()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func loadBookPages() {
        CARProvider.rx.request(.albumPage(bookId: bookId))
            .map(models: AlbumPageModel.self)
            .subscribe(onSuccess: { datas in
                self.hud.noticeHidden()
                self.colDatasourceObser.value = (datas, true)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func postAward(pageModel: AlbumPageModel) {
        if pageModel.HasAward == false { return }
        
        CARProvider.rx.request(.readAward(siteName: pageModel.SiteName,
                                          siteTitle: bookInfo.SiteTitle,
                                          siteLogo: bookInfo.SiteLogo,
                                          bookId: bookInfo.Id,
                                          bookTitle: bookInfo.Title,
                                          pageId: pageModel.Id,
                                          pageTitle: pageModel.Title))
            .mapResponseStatus()
            .subscribe(onSuccess: { [weak self] model in
                var data = self?.colDatasourceObser.value.0
                if let idx = data?.index(of: pageModel) {
                    pageModel.HasAward = false
                    data?[idx] = pageModel
                    if let tempData = data {
                        self?.colDatasourceObser.value = (tempData, false)
                    }
                }

                if let coinCount = Int(model.data ?? "0"), coinCount > 0  {
                    PrintLog("奖励金币为：\(coinCount)")
                    self?.dropCoinObser.onNext((coinCount, pageModel))
                }
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
}
