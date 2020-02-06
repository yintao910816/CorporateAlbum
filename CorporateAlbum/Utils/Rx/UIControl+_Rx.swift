//
//  UIControl+_Rx.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public var actionEnableBgColor = RGB(254, 163, 41)

extension Reactive where Base: UIButton {
    
    public var backColor: Binder<UIColor> {
        return Binder(self.base) { control, value in
            control.backgroundColor = value
        }
    }
    
    public var enabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            if value == true {
                control.backgroundColor = .clear
                control.setTitleColor(RGB(8, 172, 222), for: .normal)
                control.isUserInteractionEnabled = true
            }else {
                control.backgroundColor = .clear
                control.setTitleColor(.gray, for: .normal)
                control.isUserInteractionEnabled = false
            }
        }
    }
 
    public var actionEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            PrintLog("actionEnabled -- \(value)")
            if value == true {
                control.backgroundColor = actionEnableBgColor
                control.isUserInteractionEnabled = true
            }else {
                control.backgroundColor = RGB(204, 204, 204)
                control.isUserInteractionEnabled = false
            }
        }
    }

    public var image: Binder<String?> {
        return Binder(self.base) { button, url in
            button.setImage(url)
        }
    }
}
