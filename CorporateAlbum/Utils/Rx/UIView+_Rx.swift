//
//  UIView+_Rx.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/18.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIView {

    ///
    public var alpha: Binder<Bool> {
        return Binder(self.base) { view, enable in
            view.alpha = enable ? 1.0 : 0.5
        }
    }
    
    public var borderColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.layer.borderColor = color.cgColor
        }
    }
    
}

extension Reactive where Base: UIControl {

    public var rx_selected: Binder<Bool> {
        return Binder(self.base) { control, selected in
            control.isSelected = selected
        }
    }
}

extension Reactive where Base: UITextField {

    public var isSecureTextEntry: Binder<Bool> {
        return Binder(self.base) { tf, secure in
            tf.isSecureTextEntry = secure
        }
    }
}

extension Reactive where Base: UIImageView {

    public var image: Binder<UIImage?> {
        return Binder(self.base) { imageView, image in
            imageView.image = image
        }
    }    
}
