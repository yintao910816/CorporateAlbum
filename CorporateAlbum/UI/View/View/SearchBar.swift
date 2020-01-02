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
    
    private lazy var leftBarItem: UIButton = {
        let button = UIButton.init(type: .custom)
        button.tintColor = .clear

        button.setImage(UIImage.init(named: "arrow_down")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(UIImage.init(named: "arrow_up")?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.setTitle("全部", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 35, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 0, left: -40, bottom: 0, right: 0)

        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        return button
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
    
    var leftItemTitle: String = "" {
        didSet {
            leftBarItem.setTitle(leftItemTitle, for: .normal)
        }
    }
    
    func changeLeftItemState() {
        leftBarItem.isSelected = !leftBarItem.isSelected
    }
    
    private func setupView() {
        backgroundColor = CA_MAIN_COLOR

        addSubview(leftBarItem)
        addSubview(rightBarItem)
        addSubview(inputBgView)
        
        inputBgView.addSubview(placeholderIcon)
        inputBgView.addSubview(searchTextField)
    }
    
    private func rxBind() {
        leftItemTap = leftBarItem.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.leftBarItem.isSelected = !self.leftBarItem.isSelected
            })
        rightItemTap = rightBarItem.rx.tap.asDriver()

        searchText = searchTextField.rx.text.orEmpty.asDriver()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftBarItem.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(-12)
        }
        
        rightBarItem.snp.makeConstraints {
            $0.right.equalTo(self).offset(-10)
            $0.centerY.equalTo(leftBarItem.snp.centerY)
            $0.size.equalTo(CGSize.init(width: 25, height: 25))
        }

        inputBgView.snp.makeConstraints {
            $0.left.equalTo(leftBarItem.snp.right).offset(10)
            $0.right.equalTo(rightBarItem.snp.left).offset(-10)
            $0.centerY.equalTo(leftBarItem.snp.centerY)
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
