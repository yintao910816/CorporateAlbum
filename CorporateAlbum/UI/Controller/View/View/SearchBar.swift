//
//  DiscoverSearchBar.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/21.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchBar: UIView {
    
    var leftItemTap: Driver<Void>!
    var rightItemTap: Driver<Void>!

    var searchText: Driver<String>!

    let searchActionPublic = PublishSubject<Bool>()
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.keyboardType = .webSearch
        searchTextField.borderStyle  = .none
        searchTextField.backgroundColor = .clear
        searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchTextField.textColor = RGB(102, 102, 102)
        searchTextField.placeholder = "输入搜索类容"
        searchTextField.clearsOnBeginEditing = true
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        return searchTextField
    }()
    
    private lazy var placeholderIcon: UIImageView = {
        let placeholderIcon = UIImageView()
        placeholderIcon.image = UIImage.init(named: "tf_search")
        return placeholderIcon
    }()
    
    private lazy var inputBgView: UIView = {
        let inputBgView = UIView.init()
        inputBgView.backgroundColor = .white
        // 高30
        inputBgView.layer.cornerRadius = 15
        inputBgView.clipsToBounds = true
        return inputBgView
    }()
        
    private lazy var rightBarItem: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "nav_qr_scan"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        rxBind()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        rxBind()
    }
    
    var rightItemIsHidden: Bool = false {
        didSet {
            rightBarItem.isHidden = rightItemIsHidden
        }
    }
        
    private func setupView() {
        backgroundColor = CA_MAIN_COLOR

        addSubview(rightBarItem)
        addSubview(inputBgView)
        
        inputBgView.addSubview(placeholderIcon)
        inputBgView.addSubview(searchTextField)
    }
    
    private func rxBind() {
        rightItemTap = rightBarItem.rx.tap.asDriver()

        searchText = searchTextField.rx.text.orEmpty.asDriver()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        rightBarItem.snp.makeConstraints {
            $0.right.equalTo(self).offset(-10)
            $0.bottom.equalTo(self).offset(-12)
            $0.size.equalTo(CGSize.init(width: 25, height: 25))
        }

        inputBgView.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(rightBarItem.snp.left).offset(-10)
            $0.centerY.equalTo(rightBarItem.snp.centerY)
            $0.height.equalTo(30)
        }

        placeholderIcon.snp.makeConstraints {
            $0.left.equalTo(inputBgView).offset(15)
            $0.centerY.equalTo(inputBgView.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 30, height: 30))
        }

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(inputBgView)
            $0.bottom.equalTo(inputBgView)
            $0.left.equalTo(placeholderIcon.snp.right).offset(10)
            $0.right.equalTo(inputBgView).offset(-10)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text?.count ?? 0 > 0 {
            searchActionPublic.onNext(true)
        }
        return true
    }
}
