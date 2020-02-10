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
    
    public var companyListsDatasource = Variable([[CACompanyListModel]]())
    public let orderListDatasource = Variable([CAOrderItemInfoModel]())
    public let serverAgreementSubject = PublishSubject<Void>()
    
    public let reCalculatTotlePriceSubject = PublishSubject<Void>()
    public let totlePriceObser = Variable("￥0.0元")
    /// 填写的域名监听
    public let hostObser = Variable("")
    /// 填写的公司名称监听
    public let companyObser = Variable(CACompanyListModel())

    init(submit: Driver<Void>, agreement: Driver<Void>) {
        super.init()
        agreement
            .drive(onNext: { _ in
                CAOpenAlbumViewModel.push(WebViewController.self, ["url": APIAssistance.serviceWeb, "title": "服务协议"])
            })
            .disposed(by: disposeBag)
                
        reCalculatTotlePriceSubject
            .subscribe(onNext: { [weak self] _ in
                self?.calculatTotlePrice()
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
                self?.calculatTotlePrice()
            }) { PrintLog("获取空的订单列表信息失败：\($0)") }
            .disposed(by: disposeBag)
    }
    
    private func requestCompanyList() {
        CARProvider.rx.request(.companyList)
            .map(models: CACompanyListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.companyListsDatasource.value = [data]
            }) { PrintLog("获取公司列表出错：\($0)") }
            .disposed(by: disposeBag)
    }
}

extension CAOpenAlbumViewModel {
    
    private func calculatTotlePrice() {
        var totlePrice: Double = 0.0
        for item in orderListDatasource.value {
            totlePrice += item.Price * Double(item.Quantity)
        }
        
        totlePriceObser.value = "￥\(totlePrice)元"
    }
}
