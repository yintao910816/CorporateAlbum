//
//  CAReginCell.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/3.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

public let CAReginCell_identifier = "CAReginCell"

class CAReginCell: BaseTBCell {

    @IBOutlet weak var contentOutlet: UILabel!
    @IBOutlet weak var deleteOutlet: TYClickedButton!
    
    public var deleteCallBack: ((CARegionInfoModel)->())?
    
    @IBAction func actions(_ sender: UIButton) {
        deleteCallBack?(model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public var model: CARegionInfoModel! {
        didSet {
            contentOutlet.text = model.Title
        }
    }
    
    public var localRegionModel: CARegionListModel! {
        didSet {
            contentOutlet.text = localRegionModel.name
        }
    }
    
    public var isHiddenDelete: Bool = true {
        didSet {
            deleteOutlet.isHidden = isHiddenDelete
        }
    }
}
