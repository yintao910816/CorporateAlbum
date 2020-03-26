//
//  CAMySiteSettingViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift

enum CASiteSettingType {
    /// 修改管理密码
    case editManagePwd
    /// 续期
    case renewal
    /// 充值
    case recharge
    /// 推广区域
    case extensionAreaSetting
    
    /// 开启/关闭站点
    case controlSite
    /// 开启/关闭奖励
    case controlAward
    /// 重设奖励
    case resetAward

    public var segue: String {
        get {
            switch self {
            case .editManagePwd:
                return "resetMySitePassWordSegue"
            case .renewal:
                return ""
            case .recharge:
                return ""
            case .extensionAreaSetting:
                return "extensionAreaSettingSegue"
            default:
                return ""
            }
        }
    }
}

class CAMySiteSettingViewModel: BaseViewModel, VMNavigation {
    
    private var siteModel: CAMySiteModel!
    
    public let regionDataource = Variable([CARegionInfoModel]())
    public let siteInfoObser = Variable(CAMySiteModel())

    public let footerActionsSubject = PublishSubject<CASiteSettingType>()
    public let isOnlineObser = PublishSubject<Bool>()
    public let isAwardObser  = PublishSubject<Bool>()
    
    public let gotoPaySubject = PublishSubject<CAOpenAlbumFunctionType>()

    init(input: CAMySiteModel) {
        super.init()
        
        siteModel = input
        
        NotificationCenter.default.rx.notification(NotificationName.User.extensionRegionChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestRegionList()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.User.siteInfoChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestSiteInfo()
            })
            .disposed(by: disposeBag)
        
        footerActionsSubject
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .controlSite:
                    self?.hud.noticeLoading()
                    self?.requestControllerMySite()
                case .controlAward:
                    self?.hud.noticeLoading()
                    self?.requestControllerMySiteAward()
                case .resetAward:
                    NoticesCenter.alert(title: "提示", message: "确定要重新开始奖励吗？", cancleTitle: "取消", okTitle: "确定") {
                        self?.hud.noticeLoading()
                        self?.requestResetSiteAward()
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        gotoPaySubject
            .subscribe(onNext: {
                CAMySiteSettingViewModel.sbPush("Main", "openAlbumCtrlId",
                                                parameters: ["functionType": $0, "siteInfo": input])
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestRegionList()
            self?.siteInfoObser.value = input
            self?.isOnlineObser.onNext(input.IsOnline)
            self?.isAwardObser.onNext(input.EnabledAward)
        })
        .disposed(by: disposeBag)
    }
    
    private func requestRegionList() {
        CARProvider.rx.request(.listRegion(siteName: siteModel.SiteName))
            .map(models: CARegionInfoModel.self)
            .subscribe(onSuccess: { data in
                self.regionDataource.value = data
                
                NotificationCenter.default.post(name: NotificationName.User.reloadExtensionRegionView, object: data)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    private func requestSiteInfo() {
        CARProvider.rx.request(.getMySite(siteName: siteModel.SiteName))
            .map(model: CAMySiteModel.self)
            .subscribe(onSuccess: { [weak self] model in
                self?.siteModel = model
                self?.siteInfoObser.value = model
                self?.isOnlineObser.onNext(model.IsOnline)
                self?.isAwardObser.onNext(model.EnabledAward)

                NotificationCenter.default.post(name: NotificationName.User.reloadSiteInfoView, object: model)
            }) {
                PrintLog($0)
        }
        .disposed(by: disposeBag)
    }
    
    private func requestControllerMySite() {
        CARProvider.rx.request(.controllMySite(siteName: siteModel.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                guard let strongSelf = self else { return }
                
                if res.error == 0 {
                    strongSelf.requestSiteInfo()
                    strongSelf.hud.successHidden(res.message)
                }else {
                    strongSelf.hud.failureHidden(res.message)
                    strongSelf.isOnlineObser.onNext(strongSelf.siteModel.IsOnline)
                }
            }) { [weak self] in
                guard let strongSelf = self else { return }

                strongSelf.hud.failureHidden(strongSelf.errorMessage($0))
                strongSelf.isOnlineObser.onNext(strongSelf.siteModel.IsOnline)
        }
        .disposed(by: disposeBag)
    }
    
    private func requestControllerMySiteAward() {
        CARProvider.rx.request(.controlMySiteAward(siteName: siteModel.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                guard let strongSelf = self else { return }

                if res.error == 0 {
                    strongSelf.requestSiteInfo()
                    strongSelf.hud.successHidden(res.message)
                }else {
                    strongSelf.hud.failureHidden(res.message)
                    strongSelf.isAwardObser.onNext(strongSelf.siteModel.EnabledAward)
                }
            }) { [weak self] in
                guard let strongSelf = self else { return }

                strongSelf.hud.failureHidden(strongSelf.errorMessage($0))
                strongSelf.isAwardObser.onNext(strongSelf.siteModel.EnabledAward)
        }
        .disposed(by: disposeBag)
    }
    
    private func requestResetSiteAward() {
        CARProvider.rx.request(.resetMySiteAward(siteName: siteModel.SiteName))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if res.error == 0 {
                    self?.hud.successHidden(res.message)
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}

extension CAMySiteSettingViewModel {
    
    public func prepareParams(type: CASiteSettingType) ->[String: Any]? {
        switch type {
        case .extensionAreaSetting:
            return ["list":regionDataource.value, "site": siteModel]
        case .editManagePwd:
            return ["model": siteModel]
        default:
            return nil
        }
    }
}
