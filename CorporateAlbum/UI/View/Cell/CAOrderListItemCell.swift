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
    @IBOutlet weak var quantityOutlet: UITextField!
    @IBOutlet weak var productIntroOutlet: UILabel!
    
    public var didEndEditCallBack: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        quantityOutlet.isUserInteractionEnabled = false
        quantityOutlet.delegate = self
    }

    public var model: CAOrderItemInfoModel! {
        didSet {
            productNameOutlet.text = model.IsPromotion == 1 ? "【赠】\(model.ProductTitle)" : model.ProductTitle
            priceOutlet.text = model.priceText
            if model.Quantity > 0 { quantityOutlet.text = "\(model.Quantity)" }
            productIntroOutlet.text = model.ProductIntro
        }
    }
    
    public var quantityEnable: Bool = false {
        didSet {
            quantityOutlet.isUserInteractionEnabled = quantityEnable
        }
    }
}

extension CAOrderListItemCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.replacingOccurrences(of: " ", with: "")
        if text == nil {
            model.Quantity = 0
            didEndEditCallBack?()
            return
        }

        model.Quantity = Int(text!) ?? 0
        didEndEditCallBack?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        PrintLog(range)
        if range.location == 0, string == "0" {
            return false
        }

        return true
    }
}
