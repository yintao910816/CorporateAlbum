//
//  MyNoticesVeiwModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation

class MyNoticesViewModel: RefreshVM<NoticeInfoModel> {
    
    override init() {
        super.init()
        
        modelSelected.subscribe(onNext: { [unowned self] in self.setNoticeRead(noticeModel: $0) })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        CARProvider.rx.request(.notice(search: "", skip: pageModel.currentPage, limit: pageModel.pageSize))
            .map(models: NoticeInfoModel.self)
            .subscribe(onSuccess: { models in
                self.updateRefresh(refresh, models)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
    
    private func setNoticeRead(noticeModel: NoticeInfoModel) {
        CARProvider.rx.request(.noticeRead(id: noticeModel.Id))
            .mapResponse()
            .subscribe(onSuccess: { ret in
                if ret.error == 0 {
                    PrintLog("设置消息已读成功")
                }else {
                    PrintLog("设置消息已读失败: \(ret.message)")
                }
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
}
