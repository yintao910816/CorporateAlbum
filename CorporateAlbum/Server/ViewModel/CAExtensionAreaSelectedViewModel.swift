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
    
    private var userInfoModel: UserInfoModel!
    
    public var datasource = Variable([SectionModel<String, CARegionListModel>]())
    public var sectionTitles: [String] = []
    
    public let didSelectedSubject = PublishSubject<CARegionListModel>()
    
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
    
    private func getRegionText(model: CARegionListModel) ->String {
        var regionText: String = model.province
        if model.city.count > 0 {
            regionText.append(model.city)
        }
        if model.district.count > 0 {
            regionText.append(model.district)
        }
        return regionText
    }
}

/// 推广区域设置
extension CAExtensionAreaSelectedViewModel {
    
    /// 推广区域设置
    convenience init(siteModel: CAMySiteModel) {
        self.init()
        self.siteModel = siteModel
        
        didSelectedSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestAddRegion(model: $0)
            })
            .disposed(by: disposeBag)
    }

    private func requestAddRegion(model: CARegionListModel) {
        
        CARProvider.rx.request(.addRegion(siteName: siteModel.SiteName, regionCode: model.code, regionText: getRegionText(model: model)))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    NotificationCenter.default.post(name: NotificationName.User.extensionRegionChanged, object: nil)
                    self?.hud.successHidden("添加成功！", {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}

/// 修改个人信息地址
extension CAExtensionAreaSelectedViewModel {

    convenience init(user: UserInfoModel) {
        self.init()
        
        userInfoModel = user
        
        didSelectedSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestSetUserRegion(model: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestSetUserRegion(model: CARegionListModel) {
        let regionText = getRegionText(model: model)
        CARProvider.rx.request(.userSetRegion(regionCode: model.code, regionText: regionText))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    self?.userInfoModel.RegionTitle = regionText
                    NotificationCenter.default.post(name: NotificationName.User.userInfoEditSuccess, object: self?.userInfoModel)
                    self?.hud.successHidden("修改成功！", {
                        self?.popSubject.onNext(true)
                    })
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}
