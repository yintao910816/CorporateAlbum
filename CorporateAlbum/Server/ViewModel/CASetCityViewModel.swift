//
//  CASetCityViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/12.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CASetCityViewModel: BaseViewModel {
    
    private var locationManager: RxLocationManager!
    private var userInfo: UserInfoModel!

    public let cityObser = PublishSubject<String?>()
    public let enableSubmitSubject = PublishSubject<Bool>()
    
    init(userInfo: UserInfoModel, submit: Driver<Void>, location: Driver<Void>) {
        super.init()
        self.userInfo = userInfo
        locationManager = RxLocationManager()
        
        location
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] _ in
                PrintLog("开始定位")
                self.locationManager.starSubject.onNext(Void())
            })
            .disposed(by: disposeBag)
        
        submit
//            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] _ in
                NoticesCenter.alert(message: "保存成功")
            })
            .disposed(by: disposeBag)

        locationManager.addressSubject
            .subscribe(onNext: { [weak self] data in
                PrintLog(data.0.addressDictionary)
                self?.hud.noticeHidden()
            }, onError: { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)
    }
    
}
