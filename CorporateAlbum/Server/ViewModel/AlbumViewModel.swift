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
    
    private var allData: [String: [AlbumBookModel]] = [:]

    public let collectePublic = PublishSubject<AlbumBookModel>()
    public let menuChangeSubject = PublishSubject<Int>()
    public let beginSearchSubject = PublishSubject<Void>()

    public let searchTextObser = Variable("")
    
    override init() {
        super.init()
        
        allData["0"] = [AlbumBookModel]()

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
                if self.allData["\($0)"] == nil {
                    self.allData["\($0)"] = [AlbumBookModel]()
                    self.requestData(true)
                }else {
                    self.datasource.value = self.allData["\($0)"]!
                }
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
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.reloadUserInfo, object: nil)
            .map{ _ in true }
            .bind(to: reloadSubject)
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.updatePage(for: "\(dataType)", refresh: refresh)
        
        let dataSignal = CARProvider.rx.request(.bookList(search: searchTextObser.value,
                                                          skip: pageModel.currentPage,
                                                          limit: pageModel.pageSize,
                                                          category: dataType))
            .map(models: AlbumBookModel.self)
        
        if userDefault.appToken == nil || userDefault.appToken?.count == 0 {
            APIAssistance.requestToken().concatMap{ _ in dataSignal }
                .subscribe(onNext: { [unowned self] datas in
                    self.updateRefresh(refresh: refresh, models: datas,
                                       dataModels: &(self.allData["\(self.dataType)"]!),
                                       pageKey: "\(self.dataType)")
                    self.datasource.value = self.allData["\(self.dataType)"]!
                    AlbumBookModel.insert(datas: datas)
                    }, onError: { [unowned self] error in
                        self.revertCurrentPageAndRefreshStatus()
                })
                .disposed(by: disposeBag)
            
            return
        }
        
        dataSignal.subscribe(onSuccess: { [unowned self] datas in
                self.updateRefresh(refresh: refresh, models: datas,
                                   dataModels: &(self.allData["\(self.dataType)"]!),
                                   pageKey: "\(self.dataType)")
                self.datasource.value = self.allData["\(self.dataType)"]!
                AlbumBookModel.insert(datas: datas)
            }) { [unowned self] error in
                self.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func collectBook(model: AlbumBookModel) {
        CARProvider.rx.request(.addBook(bookId: model.Id))
            .mapResponse()
            .subscribe(onSuccess: { [unowned self] in
                if $0.error == 0 {
                    if self.allData["0"] != nil {
                        self.allData["0"] = self.allData["0"]!.map({ m -> AlbumBookModel in
                            if m.Id == model.Id {
                                m.IsFavorite = model.IsFavorite
                            }
                            return m
                        })
                    }
                    if self.allData["1"] != nil {
                        self.allData["1"] = self.allData["1"]!.map({ m -> AlbumBookModel in
                            if m.Id == model.Id {
                                m.IsFavorite = model.IsFavorite
                            }
                            return m
                        })
                    }
                    if self.allData["2"] != nil {
                        if !model.IsFavorite {
                            self.allData["2"] = self.allData["2"]!.filter{ $0.Id != model.Id }
                        }else {
                            self.allData["2"]!.append(model)
                        }
                    }

                    if self.dataType == 2 {
                        // 在收藏菜单栏点取消收藏
                        self.datasource.value = self.allData["2"]!
                    }
                    
                    self.hud.successHidden($0.message)
                }else {
                    self.hud.failureHidden($0.message)
                }
            }) { [unowned self] error in
                self.hud.failureHidden(self.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func loadCacheDatas() {
        Observable<[AlbumBookModel]>.selectedDB(type: AlbumBookModel.self, tbName: AlbumBookTB)
            .subscribe(onNext: { [weak self] in
                self?.allData["0"] = $0
                self?.datasource.value = $0
            })
            .disposed(by: disposeBag)
    }
}
