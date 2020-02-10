//
//  BaseView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/10.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseView: UIView {

    public let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        rxBind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        rxBind()
    }
    
    deinit {
        PrintLog("释放了：\(self)")
    }
    
    /// 数据绑定
    public func rxBind() { }
    /// UI设置
    public func setupUI() { }
}
