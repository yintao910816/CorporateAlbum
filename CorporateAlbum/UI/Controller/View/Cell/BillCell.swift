//
//  BillCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var createTimeOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var amountOutlet: UILabel!
    
    var model: BillInfoModel! {
        didSet {            
            coverOutlet.setImage(model.Picture)
            titleOutlet.text = model.CashTypeTitle
            createTimeOutlet.text = model.CreateTime
            summaryOutlet.text = model.Summary
            amountOutlet.text = "+\(model.Amount)元"
        }
    }
}
