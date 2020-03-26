//
//  AlbumInfoViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumInfoViewModel: BaseViewModel, VMNavigation {
    
    private var bookId: String!
    private var bookInfo: AlbumBookModel!
    
    private let timer = CountdownTimer.init(totleCount: 3)
    private var pageModel: CAPageListModel?
    
    // (collectionView数据源，刷新col时是否重新设置pageVC)
    public var colDatasourceObser = Variable(([CAPageListModel](), true))
    
    public var pageSelctedAward = PublishSubject<CAPageListModel>()
    public var shouldShowAlertSubject = PublishSubject<(CAPageListModel, AlbumBookModel)>()
    public var postRewordsSubject = PublishSubject<CAPageListModel>()

    public var dropCoinObser = PublishSubject<(Int, CAPageListModel)>()
    public var iconObser = PublishSubject<String>()

    init(bookId: String, tapIconDriver: Driver<Void>) {
        super.init()
        
        self.bookId = bookId
        
        timer.showText.asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .filter({ [weak self] seconds -> Bool in
                guard let strongSelf = self else { return false }
                if seconds == 0 {
                    PrintLog("暂停")
                    strongSelf.timer.timerPause()
                    return true
                }
                return false
            })
            .map { [weak self] _ in (self?.pageModel ?? CAPageListModel(), self?.bookInfo ?? AlbumBookModel()) }
            .bind(to: shouldShowAlertSubject)
            .disposed(by: disposeBag)
        
        pageSelctedAward
            .filter{ _ in CACoreLogic.isUserLogin() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                if model.EnabledAward == true {
                    self?.timer.timerPause()
                    self?.pageModel = model
                    self?.timer.timerStar()
                }
            })
            .disposed(by: disposeBag)
        
        postRewordsSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                self?.postAward(pageModel: $0)
            })
            .disposed(by: disposeBag)
        
        tapIconDriver
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                AlbumInfoViewModel.sbPush("Main", "siteAlbumCtrlID", parameters: ["siteName": strongSelf.bookInfo.SiteName])
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
                self?.iconObser.onNext(book.AppLogo)
                self?.loadBookPages()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func loadBookPages() {
//        CARProvider.rx.request(.albumPage(siteName: bookInfo.SiteName, skip: 0, limit: 32))
//            .map(models: AlbumPageModel.self)
//            .subscribe(onSuccess: { datas in
//                self.hud.noticeHidden()
//                self.colDatasourceObser.value = (datas, true)
//            }) { [weak self] error in
//                self?.hud.failureHidden(self?.errorMessage(error))
//            }
//            .disposed(by: disposeBag)
        
        CARProvider.rx.request(.pageList(bookId: bookId, skip: 0, limit: 100))
            .map(models: CAPageListModel.self)
            .subscribe(onSuccess: { datas in
                self.hud.noticeHidden()
                self.colDatasourceObser.value = (datas, true)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func postAward(pageModel: CAPageListModel) {
        CARProvider.rx.request(.readAward(siteName: pageModel.SiteName,
                                          bookId: pageModel.BookId,
                                          bookTitle: bookInfo.Title,
                                          pageId: pageModel.Id,
                                          pageTitle: pageModel.Title))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] model in
                if model.error == 0 {
                    var data = self?.colDatasourceObser.value.0
                    if let idx = data?.firstIndex(of: pageModel) {
                        pageModel.IsAwarded = true
                        data?[idx] = pageModel
                        if let tempData = data {
                            self?.colDatasourceObser.value = (tempData, false)
                        }
                    }
                    
                    self?.hud.successHidden("领取成功！")
                }else {
                    self?.hud.failureHidden(model.message)
                }

//                if let coinCount = Int(model.data ?? "0"), coinCount > 0  {
//                    PrintLog("奖励金币为：\(coinCount)")
//                    self?.dropCoinObser.onNext((coinCount, pageModel))
//                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
