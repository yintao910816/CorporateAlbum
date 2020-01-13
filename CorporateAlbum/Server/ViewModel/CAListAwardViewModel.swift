//
//  CAListAwardViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift

class CAListAwardViewModel: RefreshVM<BillInfoModel> {
    
    private var searchText: String = ""

    public let beginSearchSubject = PublishSubject<Void>()

    init(searchTextObser: Observable<String>) {
        super.init()
    
        searchTextObser
            .subscribe(onNext: { [unowned self] in
                self.searchText = $0
            })
            .disposed(by: disposeBag)
                
        beginSearchSubject
            .subscribe(onNext: { [unowned self] in
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        itemSelected.subscribe(onNext: { [unowned self] indexPath in
//            let model = self.datasource.value[indexPath.row]
//           CorporateViewModel.sbPush("Main", "siteAlbumCtrlID",
//                                     bundle: Bundle.main,
//                                     parameters: ["siteName": model.SiteName, "title": model.SiteTitle])
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
        
        CARProvider.rx.request(.billListAward(search: searchText,
                                              skip: pageModel.currentPage,
                                              limit: pageModel.pageSize))
            .map(models: BillInfoModel.self)
            .subscribe(onSuccess: { [weak self] datas in
                self?.updateRefresh(refresh, datas)
            }) { [unowned self] error in
                    self.revertCurrentPageAndRefreshStatus()
            }
        .disposed(by: disposeBag)
    }

}
