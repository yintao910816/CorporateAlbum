//
//  CAOpenAlbumViewModel.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum CAOpenAlbumType {
    /// 网站空间
    case websiteSpace(num: Int)
    /// 画册编辑
    case albumEditor(num: Int)
    /// 母版定制
    case masterCustomization(num: Int)
    /// 现金充值
    case recharge(num: Int)
    /// 独享主机
    case exclusiveHost(num: Int)
}

class CAOpenAlbumViewModel: BaseViewModel, VMNavigation {
    
    private var companyLists: [TYPickerDatasource] = []
    
    public let orderListDatasource = Variable([CAOrderItemInfoModel]())
    public let serverAgreementSubject = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        serverAgreementSubject
            .subscribe(onNext: { _ in
                CAOpenAlbumViewModel.push(WebViewController.self, ["url": APIAssistance.serviceWeb, "title": "服务协议"])
            })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestCompanyList()
                self?.requestOrderList()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestOrderList() {
        CARProvider.rx.request(.orderCreateNew)
            .map(models: CAOrderItemInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.orderListDatasource.value = data
            }) { PrintLog("获取空的订单列表信息失败：\($0)") }
            .disposed(by: disposeBag)
    }
    
    private func requestCompanyList() {
        CARProvider.rx.request(.companyList)
            .map(models: CACompanyListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.companyLists.removeAll()
                self?.companyLists.append(contentsOf: data)
            }) { PrintLog("获取公司列表出错：\($0)") }
            .disposed(by: disposeBag)
    }
    
    public var pickerSource: [[TYPickerDatasource]] {
        get {
            return companyLists.count > 0 ? [companyLists] : []
        }
    }
}
