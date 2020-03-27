//
//  CAMySiteLogCell.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/15.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

public let CAMySiteLogCell_identifier = "CAMySiteLogCell"
public let CAMySiteLogCell_height: CGFloat = 70

class CAMySiteLogCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    
    public var model: CAMySiteLogInfoModel! {
        didSet {
            titleOutlet.text = model.CreateTime
            desOutlet.text = model.Summary
        }
    }
}
