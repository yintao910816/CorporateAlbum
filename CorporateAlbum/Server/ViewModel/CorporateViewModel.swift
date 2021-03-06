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
    
    // 0:全部,1:推荐,2:收藏
    private var dataType: Int = 0
    private var allData: [String: [SiteInfoModel]] = [:]

    public var collectePublic = PublishSubject<SiteInfoModel>()
    public let menuChangeSubject = PublishSubject<Int>()
    public let beginSearchSubject = PublishSubject<Void>()
    
    private var searchText: String = ""
    
    init(searchTextObser: Observable<String>) {
        super.init()
    
        allData["0"] = [SiteInfoModel]()

        searchTextObser
            .subscribe(onNext: { [unowned self] in
                self.searchText = $0
            })
            .disposed(by: disposeBag)
        
        menuChangeSubject
            .subscribe(onNext: { [unowned self] in
                self.dataType = $0
                if self.allData["\($0)"] == nil {
                    self.allData["\($0)"] = [SiteInfoModel]()
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
                                     parameters: ["siteName": model.SiteName])
        })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Album.SiteRewardChanged, object: nil)
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
        
        CARProvider.rx.request(.siteList(category: dataType,
                                         search: searchText,
                                         skip: pageModel.currentPage,
                                         limit: pageModel.pageSize))
            .map(models: SiteInfoModel.self)
            .subscribe(onSuccess: { [unowned self] datas in
                self.updateRefresh(refresh: refresh, models: datas,
                                   dataModels: &(self.allData["\(self.dataType)"]!),
                                   pageKey: "\(self.dataType)")
                self.datasource.value = self.allData["\(self.dataType)"]!
                SiteInfoModel.insert(datas: datas)
            }) { [unowned self] error in
                self.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
    
    private func collectSite(model: SiteInfoModel) {
        CARProvider.rx.request(.siteFavorite(siteName: model.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [unowned self] res in
                if res.error == 0 {
                    if self.allData["0"] != nil {
                        self.allData["0"] = self.allData["0"]!.map({ m -> SiteInfoModel in
                            if m.Id == model.Id {
                                m.IsFavorite = model.IsFavorite
                            }
                            return m
                        })
                    }
                    if self.allData["1"] != nil {
                        self.allData["1"] = self.allData["1"]!.map({ m -> SiteInfoModel in
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

                    self.hud.successHidden(res.message)
                }else {
                    self.hud.failureHidden(res.message)
                }
            }) { [unowned self] error in
                self.hud.failureHidden(self.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func loadCacheDatas() {
        Observable<[SiteInfoModel]>.selectedDB(type: SiteInfoModel.self, tbName: SiteInfoTB)
            .subscribe(onNext: { [weak self] in
                self?.allData["0"] = $0
                self?.datasource.value = $0
            })
            .disposed(by: disposeBag)
    }
}
