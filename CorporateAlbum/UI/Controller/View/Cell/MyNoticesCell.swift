//
//  MyNoticesCell.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/30.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class MyNoticesCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var summaryOutlet: UILabel!
    @IBOutlet weak var createTimeOutlet: UILabel!
    
    @IBOutlet weak var isNewOutlet: UIImageView!
    @IBOutlet weak var isNewWidthCns: NSLayoutConstraint!
    
    var model: NoticeInfoModel! {
        didSet {
            coverOutlet.setImage(model.Picture)
            titleOutlet.text = model.Title
            summaryOutlet.text = model.Summary
            createTimeOutlet.text = model.CreateTime
            
            isNewWidthCns.constant = model.IsNewest == true ? 8 : 0
        }
    }
}

extension MyNoticesCell {
    
    class func cellHeight(_ model: NoticeInfoModel) ->CGFloat {
        // 到描述顶部高度
        var height: CGFloat = 15 + 3 + 18 + 5
        // 加上描述文字的高度
        height += model.Summary.getTextHeigh(fontSize: 14, width: PPScreenW - 15 * 2 - 10)
        // 加上描述文字以下高度
        height += 3 + 17 + 15 + 12
        
        let minHeight: CGFloat = 15 * 2 + 85
        
        return max(height, minHeight)
    }
}
