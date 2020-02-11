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
        
        let sourceSignal = Driver.combineLatest(hostObser.asDriver(), companyObser.asDriver(), orderListDatasource.asDriver()){ ($0, $1.Id, JsonUtils.json(with: $2)) }
        
        submit.withLatestFrom(sourceSignal)
            .filter{ [unowned self] in return self.judgeSubmit(siteName: $0.0, companyId: $0.1, json: $0.2) }
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                self.requestSubmitOrder(siteName: $0.0, companyId: $0.1, orderJson: $0.2!)
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
    
    private func requestSubmitOrder(siteName: String, companyId: String, orderJson: String) {
        CARProvider.rx.request(.orderSubmitNew(siteName: siteName, companyId: companyId, orderJson: orderJson))
            .map(model: CAOrderInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()
                CAOpenAlbumViewModel.sbPush("Main", "orderListItemsCtrl", parameters: ["model": data, "isPopToOrderList":true])
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
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
    
    private func judgeSubmit(siteName: String, companyId: String, json: String?) ->Bool {
        if siteName.count == 0 {
            NoticesCenter.alert(message: "请填写站点域名")
            return false
        }
        
        if companyId == "0" {
            NoticesCenter.alert(message: "请选择所属公司")
            return false
        }
        
        if json == nil || json?.count == 0 {
            NoticesCenter.alert(message: "订单项异常")
            return false
        }
        
        return true
    }
}
