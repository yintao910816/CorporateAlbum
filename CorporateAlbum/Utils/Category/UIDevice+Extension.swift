//
//  UIDevice+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/11/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

extension UIDevice {
    
    /**
     判断是否为iPhone X
     */
    public var isX: Bool { return UIScreen.main.bounds.size.height == 812 }
}
