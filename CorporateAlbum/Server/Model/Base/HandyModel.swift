//
//  BaseModel.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import HandyJSON

class HJModel:NSObject ,HandyJSON {
    
    func mapping(mapper: HelpingMapper) {}
    
    required override init() {}
    
}

protocol DatasourceModelAdapt { }
