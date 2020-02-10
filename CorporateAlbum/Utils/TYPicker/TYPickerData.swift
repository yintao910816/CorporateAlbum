//
//  TYPickerData.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

/// 数据源获取
protocol TYPickerDatasource {
        
    var contentAttribute: NSAttributedString { get }
}
