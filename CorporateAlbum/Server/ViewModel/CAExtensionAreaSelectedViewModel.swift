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
    
    public var datasource = Variable([SectionModel<String, CARegionListModel>]())
    public var sectionTitles: [String] = []
    
    override init() {
        super.init()
        
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
}
