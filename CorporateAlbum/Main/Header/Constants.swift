//
//  SRMacro.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/10/28.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import UIKit

public func RGB(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat = 1) ->UIColor{
    return UIColor(red : r / 255.0 ,green : g / 255.0 ,blue : b / 255.0 ,alpha : a)
}

let CA_MAIN_COLOR        = RGB(32, 135, 20)
let CA_LIGHT_GRAY_COLOR  = RGB(242, 242, 242)

let CA_SEPRATE_LINE_COLOR  = RGB(242, 242, 242)
