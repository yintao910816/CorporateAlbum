//
//  UINavigationController+BarButtonItem.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/2.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension UIViewController {
    
    @discardableResult
    public final func addBarItem(normal normalImage: String? = nil,
                                 selected selectedImage: String? = nil,
                                 title itemTitle: String? = nil,
                                 titleColor color: UIColor? = UIColor.white,
                                 right isRight: Bool = true,
                                 forImage imageInset: UIEdgeInsets? = nil,
                                 forTitle titleInset: UIEdgeInsets? = nil,
                                 to disposed: DisposeBag = DisposeBag(),
                                 _ action: @escaping () ->Void) ->UIButton {
        let button = createButton(normalImage, selectedImage, itemTitle, color, imageInset, titleInset)
        isRight == true ? (navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button))
            : (navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button))

        button.rx
            .controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { action() })
            .disposed(by: disposed)
        
        return button
    }
    
    public final func addBarItem(normal normalImage: String? = nil,
                                 selected selectedImage: String? = nil,
                                 title itemTitle: String? = nil,
                                 titleColor color: UIColor? = UIColor.white,
                                 right isRight: Bool = true) ->Driver<Void> {
        let button = createButton(normalImage, selectedImage, itemTitle, color, nil, nil)
        isRight == true ? (navigationItem.rightBarButtonItem = UIBarButtonItem(customView:button))
            : (navigationItem.leftBarButtonItem = UIBarButtonItem(customView:button))
        
        return button.rx.tap.asDriver()
    }
    
    private func createButton(_ normalImage: String?,
                              _ selectedImage: String?,
                              _ itemTitle: String?,
                              _ titleColor: UIColor?,
                              _ imageInset: UIEdgeInsets?,
                              _ titleInset: UIEdgeInsets?) ->UIButton {
        let button : UIButton = UIButton(type : .custom)
        button.tintColor = .clear

        if normalImage?.isEmpty == false {
            button.setImage(UIImage(named :normalImage!)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if selectedImage?.isEmpty == false {
            button.setImage(UIImage(named :selectedImage!)?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
        if itemTitle?.isEmpty == false {
            button.setTitle(itemTitle, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
        }
        if let inset = imageInset {
            button.imageEdgeInsets = inset
        }
        if let inset = titleInset {
            button.titleEdgeInsets = inset
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        
        return button
    }
}
