//
//  CAExtensionAreaSelectedViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/4.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class CAExtensionAreaSelectedViewModel: BaseViewModel {
    
    private var siteModel: CAMySiteModel!
    
    public var datasource = Variable([SectionModel<String, CARegionListModel>]())
    public var sectionTitles: [String] = []
    
    public let addSubject = PublishSubject<CARegionListModel>()
    
    init(siteModel: CAMySiteModel) {
        super.init()
        self.siteModel = siteModel
        
        addSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestAddRegion(model: $0)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [unowned self] _ in
            self.prepareData()
        })
        .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        CARegionListModel.prepareRegionListData { [weak self] datas in
            guard let strongSelf = self else { return }
            
            var sectionDatas: [SectionModel<String, CARegionListModel>] = []
            for (key, value) in datas {
                strongSelf.sectionTitles.append(key.uppercased())
                sectionDatas.append(SectionModel.init(model: key, items: value))
            }
            
            strongSelf.datasource.value = sectionDatas
        }
    }
    
    private func requestAddRegion(model: CARegionListModel) {
        var regionText: String = model.province
        if model.city.count > 0 {
            regionText.append(model.city)
        }
        if model.district.count > 0 {
            regionText.append(model.district)
        }
        
        CARProvider.rx.request(.addRegion(siteName: siteModel.SiteName, regionCode: model.code, regionText: regionText))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    NotificationCenter.default.post(name: NotificationName.User.extensionRegionChanged, object: nil)
                    self?.hud.successHidden("添加成功！")
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
