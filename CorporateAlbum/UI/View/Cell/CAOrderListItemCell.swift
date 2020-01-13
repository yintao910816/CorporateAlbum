//
//  CAOrderListItemCell.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/13.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

public let CAOrderListItemCell_identifier = "CAOrderListItemCell"
public let CAOrderListItemCell_height: CGFloat = 80

class CAOrderListItemCell: UITableViewCell {

    @IBOutlet weak var productNameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UILabel!
    @IBOutlet weak var productIntroOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    public var model: CAOrderItemInfoModel! {
        didSet {
            productNameOutlet.text = model.ProductTitle
            priceOutlet.text = model.priceText
            quantityOutlet.text = "\(model.Quantity)"
            productIntroOutlet.text = model.ProductIntro
        }
    }
}
