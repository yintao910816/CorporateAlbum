//
//  CAScanRemindViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/13.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class CAScanRemindViewController: BaseViewController {

    @IBOutlet weak var remindOutlet: UILabel!
    
    private var remindText: String?
    
    override func setupUI() {
        remindOutlet.text = remindText
    }
    
    override func prepare(parameters: [String : Any]?) {
        remindText = parameters?["text"] as? String
    }
}
