//
//  PageModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/9.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class PageModel: NSObject {

    //
    lazy var skip  = 0
    // 总共分页数
    lazy var totlePage    = 1
    // 每页多少条数据
    lazy var pageSize     = 32
    // 总共数据条数
    lazy var totle        = 1

//    public var hasNext: Bool {
//        get {
//            totlePage = (totle / pageSize) + (totle % pageSize == 0 ? 0 : 1)
//            return currentPage < totlePage
//        }
//    }

//    public var hasNext: Bool {
//        get {
//            return totlePage > 0
//        }
//    }
    
    public func hasNext(dataCount: Int) ->Bool {
        return dataCount == pageSize
    }

    /**
     发起请求钱调用
     */
    public func setupSkip(refresh: Bool, totleData: Int) {
        skip = refresh ? 0 : totleData
    }
}
