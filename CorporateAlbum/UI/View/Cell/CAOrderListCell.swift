//
//  CAOrderListCell.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

public let CAOrderListCell_identifier = "CAOrderListCell"
public let CAOrderListCell_height: CGFloat = 144

class CAOrderListCell: UITableViewCell {

    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var orderMoneyOutlet: UILabel!
    @IBOutlet weak var siteContentOutlet: UILabel!
    @IBOutlet weak var orderContentOutlet: UILabel!
    @IBOutlet weak var payAmountOutlet: UILabel!
    @IBOutlet weak var orderStatusOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public var model: CAOrderInfoModel! {
        didSet {
            timeOutlet.text = model.CreateTime
            orderMoneyOutlet.text = model.priceText
            siteContentOutlet.text = model.SiteName
            orderContentOutlet.text = model.Products
            payAmountOutlet.text = model.paidText
            orderStatusOutlet.text = model.StatusTitle
        }
    }
    
}
