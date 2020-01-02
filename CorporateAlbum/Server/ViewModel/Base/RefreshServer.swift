//
//  Protocol.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/6.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift

extension UIScrollView {

    final func prepare<T>(_ ower: RefreshVM<T>, _ type: T.Type, _ showFooter: Bool = false) {
        addFreshView(ower, showFooter)
        bind(ower, type, showFooter)
    }
    
    final func headerRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            self?.mj_header.beginRefreshing()
        }
    }
}

extension UIScrollView {

    fileprivate func addFreshView<T>(_ ower: RefreshVM<T>, _ showFooter: Bool) {
        mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            ower.requestData(true)
        })
        
        if showFooter == true {
            mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                ower.requestData(false)
            })
            mj_footer.isHidden = true
//            self.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
//                ower.requestData(false)
//            })
        }
    }
    
    fileprivate func bind<T>(_ ower: RefreshVM<T>, _ type: T.Type, _ hasFooter: Bool = true) {
        
        _ = ower.refreshStatus
            .asObservable()
            .bind(onNext: { [weak self] statue in
                
                switch statue {
                case .DropDownSuccess:
                    self?.mj_header.endRefreshing()
                    if hasFooter == true {
                        self?.mj_footer.isHidden = false
//                        self?.mj_footer.resetNoMoreData()
                    }
                    break
                case .DropDownSuccessAndNoMoreData:
                    self?.mj_header.endRefreshing()
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
//                        self?.mj_footer.endRefreshingWithNoMoreData()
                    }
                    break
                case .PullSuccessHasMoreData:
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
                    break
                case .PullSuccessNoMoreData:
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
//                        self?.mj_footer.endRefreshingWithNoMoreData()
                    }
                    break
                case .InvalidData:
                    self?.mj_header.endRefreshing()
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
                    break
                }
            })
        
    }

}

enum RefreshStatus: Int {
   
    case DropDownSuccess              // 下拉成功，有更多的数据
    case DropDownSuccessAndNoMoreData // 下拉成功，并且没有更多数据了
    case PullSuccessHasMoreData       // 上拉，还有更多数据
    case PullSuccessNoMoreData        // 上拉，没有更多数据
    case InvalidData                  // 无效的数据
}

class RefreshVM<T>: BaseViewModel {
    
    public var datasource    = Variable([T]())
    public var pageModel     = PageModel()
    public var refreshStatus = Variable(RefreshStatus.InvalidData)
 
    public let itemSelected = PublishSubject<IndexPath>()
    public let modelSelected = PublishSubject<T>()

    /**
     子类重写，必须调用super
     */
    func requestData(_ refresh: Bool) {
        setupPage(refresh: refresh)
    }

}

extension RefreshVM {

    /**
     刷新方法，发射刷新信号
     */
    public final func updateRefresh(_ refresh: Bool, _ models: [T]?, _ totle: Int?, _ addData: Bool = true) {
//        pageModel.totle = totle ?? 0
        if refresh {  // 下拉刷新处理
            refreshStatus.value = (pageModel.hasNext(dataCount: totle ?? 0)) == true ? .DropDownSuccess : .DropDownSuccessAndNoMoreData
            if addData == true { datasource.value = models ?? [T]() }
        } else { // 上拉刷新处理
            refreshStatus.value = (pageModel.hasNext(dataCount: totle ?? 0)) == true ? .PullSuccessHasMoreData : .PullSuccessNoMoreData
            if addData == true { datasource.value.append(contentsOf: (models ?? [T]())) }
        }
    }
    
    public final func stopRefresh() {
        refreshStatus.value = .DropDownSuccess
    }
    
    /**
     网络请求失败和出错都会统一调用这个方法
     */
    public final func revertCurrentPageAndRefreshStatus() {
        // 修改刷新view的状态
        refreshStatus.value = .InvalidData
    }
    
    fileprivate func setupPage(refresh: Bool) {
        pageModel.setupSkip(refresh: refresh, totleData: datasource.value.count)
    }

}
