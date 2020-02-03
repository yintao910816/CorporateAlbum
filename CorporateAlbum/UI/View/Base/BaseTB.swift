//
//  BaseTB.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxSwift

class BaseTB: UITableView {
    
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorStyle = .none
        
        if #available(iOS 11, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
        rx.itemSelected.asDriver()
            .drive(onNext: { [unowned self] in self.deselectRow(at: $0, animated: true) })
        .disposed(by: disposeBag)
    }
    
    deinit {
        PrintLog("释放了：\(self)")
    }
}
