//
//  TYListMenuData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/28.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class TYListMenuModel {
    var title: String = ""
    var titleFont: UIFont = .font(fontSize: 13, fontName: .PingFRegular)
    var titleNormalColor: UIColor = RGB(153, 153, 153)
    var titleSelectColor: UIColor = CA_MAIN_COLOR
    var isAutoWidth: Bool = true
    
    var titleIconNormalImage: UIImage?
    var titleIconSelectedImage: UIImage?
        
    var iconMargin: CGFloat = 5
    var margin: CGFloat = 15

    var isSelected: Bool = false
    
    var titleWidth: CGFloat {
        get {
            return self.title.ty_textSize(font: self.titleFont, width: CGFloat(MAXFLOAT), height: 30).width
        }
    }
    
    var titleColor: UIColor {
        get {
            return isSelected ? titleSelectColor : titleNormalColor
        }
    }
    
    var titleImage: UIImage? {
        get {
            return isSelected ? titleIconSelectedImage : titleIconNormalImage
        }
    }

    public func didClicked() {
        isSelected = !isSelected
    }
        
    class func creat(with title: String,
                     titleFont: UIFont = .font(fontSize: 13, fontName: .PingFRegular),
                     titleNormalColor: UIColor = RGB(153, 153, 153),
                     titleSelectColor: UIColor = CA_MAIN_COLOR,
                     isSelected: Bool = false,
                     titleIconNormalImage:UIImage? = nil,
                     titleIconSelectedImage:UIImage? = nil,
                     iconMargin: CGFloat = 5,
                     margin: CGFloat = 15) ->TYListMenuModel
    {
        let model = TYListMenuModel()
        model.title = title
        model.titleFont = titleFont
        model.titleNormalColor = titleNormalColor
        model.titleNormalColor = titleSelectColor
        model.isSelected = isSelected
        model.titleIconNormalImage = titleIconNormalImage
        model.titleIconSelectedImage = titleIconSelectedImage
        model.iconMargin = margin
        model.margin = margin

        return model
    }
}

extension TYListMenuModel {
    /// 首页菜单栏数据
    public class func createHomeMenu() ->[TYListMenuModel] {
        let m1 = TYListMenuModel()
        m1.isSelected = true
        m1.titleFont = .font(fontSize: 15)
        m1.title = "全部"
        
        let m2 = TYListMenuModel()
        m2.titleFont = .font(fontSize: 15)
        m2.title = "推荐"

        let m3 = TYListMenuModel()
        m2.titleFont = .font(fontSize: 15)
        m3.title = "收藏"

        return [m1, m2, m3]
    }
}
