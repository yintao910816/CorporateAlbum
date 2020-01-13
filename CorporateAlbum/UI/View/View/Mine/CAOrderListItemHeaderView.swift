//
//  CAOrderListItemHeaderView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class CAOrderListItemHeaderView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var orderTimeOutlet: UILabel!
    @IBOutlet weak var siteContentOutlet: UILabel!
    @IBOutlet weak var orderPriceOutlet: UILabel!
    @IBOutlet weak var orderPayAmountOutlet: UILabel!
    @IBOutlet weak var orderStatusOutlet: UILabel!
    
    public static let viewHeight: CGFloat = 300
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("CAOrderListItemHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.frame = bounds
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public var model: CAOrderInfoModel! {
        didSet {
            orderTimeOutlet.text = model.CreateTime
            siteContentOutlet.text = model.SiteName
            orderPriceOutlet.text = model.priceText
            orderPayAmountOutlet.text = "￥\(model.Paid)"
            orderStatusOutlet.text = model.StatusTitle
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }

}
