//
//  SetAvatarViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/7.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift

class SetAvatarViewModel: BaseViewModel {
    
    var submitAvatarSetSubject = PublishSubject<UIImage?>()
    
    override init() {
        super.init()
        
        submitAvatarSetSubject
            .filter{ $0 != nil }
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] image in
                self.postSetAvatarRequest(image: image!)
            })
            .disposed(by: disposeBag)
    }
    
    private func postSetAvatarRequest(image: UIImage) {
        CARProvider.rx.request(.setAvatar(image: image))
            .mapResponseStatus()
            .subscribe(onSuccess: { [weak self] ret in
                if ret.error == 0 {
                    self?.hud.successHidden("操作成功！")
                    self?.popSubject.onNext(true)
                }else {
                    self?.hud.failureHidden(ret.message)
                }
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
