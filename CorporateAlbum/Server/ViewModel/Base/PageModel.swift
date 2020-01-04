//
//  PageModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/12/9.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

class PageModel: NSObject {

    /// 当前总共加载了多少条数据
    public var currentPage  = 0
    /// 每次最多加载d多少条数据
    public var pageSize     = 32
    
    public func hasNext(_ currentPageDataCount: Int) ->Bool {
        return currentPageDataCount >= pageSize
    }    
}
