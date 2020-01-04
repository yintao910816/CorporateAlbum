//
//  TYSlideMenuView.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/1/4.
//  Copyright © 2020 yintao. All rights reserved.
//

import UIKit

class TYSlideMenuView: UIView {
    
    private var collectionView: UICollectionView!
    private var bottomView: UIView!
    
    private var lastSelected: Int = 0
    public var menuSelect: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        
        bottomView = UIView()
        bottomView.backgroundColor = RGB(235, 235, 235)
        addSubview(bottomView)
        
        collectionView.register(TYSlideCell.self, forCellWithReuseIdentifier: UICollectionViewCell_identifier)
    }
    
    public func setMenu(index: Int) {
        datasource[index].isSelected = true
        datasource[lastSelected].isSelected = false
        collectionView.reloadData()
        
        lastSelected = index
    }
    
    public var datasource: [TYListMenuModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        bottomView.frame = .init(x: 0, y: height - 1, width: width, height: 1)
    }
}

extension TYSlideMenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell_identifier, for: indexPath) as! TYSlideCell)
        cell.model = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (PPScreenW - 1) / 3, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuSelect?(indexPath.row)

        if lastSelected != indexPath.row {
            datasource[indexPath.row].isSelected = true
            datasource[lastSelected].isSelected = false
            collectionView.reloadData()
            
            lastSelected = indexPath.row
        }
    }
}

//MARK: -- Cell
private let UICollectionViewCell_identifier = "UICollectionViewCell"
class TYSlideCell: UICollectionViewCell {
    private var titleLabel: UILabel!
    private var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.font = .font(fontSize: 14)
        addSubview(titleLabel)
        
        bottomLine = UIView()
        bottomLine.backgroundColor = CA_MAIN_COLOR
        insertSubview(bottomLine, aboveSubview: titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: TYListMenuModel! {
        didSet {
            titleLabel.font = model.titleFont
            titleLabel.text = model.title
            titleLabel.textColor = model.titleColor
            
            bottomLine.isHidden = !model.isSelected
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
        bottomLine.frame = .init(x: 0, y: height - 2, width: width, height: 2)
    }
}
