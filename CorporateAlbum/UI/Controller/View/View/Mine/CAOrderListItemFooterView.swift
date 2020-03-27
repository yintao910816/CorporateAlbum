//
//  CAOrderListItemFooterView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/11.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOrderListItemFooterView: BaseView {

    public static let viewHeight: CGFloat = 164

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var submitOutlet: UIButton!
    
    override func setupUI() {
        contentView = (Bundle.main.loadNibNamed("CAOrderListItemFooterView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
    }
    
    override func rxBind() {
        
    }
}
