//
//  HCPickerView.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class TYPickerView: TYPicker {

    public let datasourceSignal = Variable([[TYPickerDatasource]]())

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        
        datasourceSignal.asDriver()
            .drive(onNext: { [weak self] in self?.datasource = $0 })
            .disposed(by: disposeBag)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let containViewHeight = pickerHeight + 44
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        picker.frame = .init(x: 0, y: 44, width: containerView.width, height: pickerHeight)

        containerView.addSubview(picker)
        
        containerView.transform = .init(translationX: 0, y: pickerHeight + 44)

        show(animotion: true)
    }
    
    //MARK: - lazy
    private lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = .white
        p.delegate = self
        p.dataSource = self
        return p
    }()
    
    //MARK: - interface
    public var datasource: [[TYPickerDatasource]] = [] {
        didSet {
            for idx in 0..<datasource.count {
                selectedDatas[idx] = datasource[idx][0]
            }
            
            picker.reloadAllComponents()
        }
    }
        
    override var pickerHeight: CGFloat {
        didSet {
            var frame = picker.frame
            frame.size.height = pickerHeight
            picker.frame = frame
            
            frame = containerView.frame
            frame.size.height = pickerHeight + 44
            frame.origin.y = view.width - (frame.size.height)
            containerView.frame = frame
            
            containerView.transform = .init(translationX: 0, y: pickerHeight + 44)
        }
    }
}

extension TYPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource[component].count
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDatas[component] = datasource[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return datasource[component][row].contentAttribute
    }
}


public enum TYPickerAction {
    case cancel
    case ok
}

class TYPicker: UIViewController {
        
    public var toolBar: UIToolbar!
    public var tapGes: UITapGestureRecognizer!
    public var containerView: UIView!
    public var cancelButton: UIButton!
    public var doneButton: UIButton!

    public var titleDes: String = ""
    public var cancelTitle: String = "取消"
    public var okTitle: String = "完成"
    /// 取消按钮是否有除了隐藏picker的其它功能
    public var isCustomCancel: Bool = false

    public var selectedDatas: [Int: TYPickerDatasource] = [:]
    public var finishSelected: (([Int: TYPickerDatasource])->())?
    
    public let finishSelectedSubject = PublishSubject<[Int: TYPickerDatasource]>()

    public var pickerHeight: CGFloat = 150
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = RGB(10, 10, 10, 0.2)

        ///
        containerView = UIView.init(frame: .init(x: 0, y: view.height - self.pickerHeight - 44, width: view.width, height: self.pickerHeight + 44))
        view.addSubview(containerView)
        
        toolBar = UIToolbar.init()
        
        cancelButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)
                
        let titleLable = UILabel.init(frame: .init(x: 0, y: 0, width: view.width - 80, height: 44))
        titleLable.font = .font(fontSize: 14)
        titleLable.textAlignment = .center
        titleLable.textColor = .black
        titleLable.text = titleDes

        doneButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        doneButton.setTitle(okTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)

        toolBar.items = [UIBarButtonItem.init(customView: cancelButton),
                         UIBarButtonItem.init(customView: titleLable),
                         UIBarButtonItem.init(customView: doneButton)]

        containerView.addSubview(toolBar)
        toolBar.frame = .init(x: 0, y: 0, width: view.width, height: 44)
        
        ///
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() {
        hidden(animotion: true, complement: nil)
    }
    
    @objc func cancelAction() {
        hidden(animotion: true, complement: nil)
    }
    
    @objc func doneAction() {
        hidden(animotion: true, complement: nil)
        finishSelected?(selectedDatas)
        finishSelectedSubject.onNext(selectedDatas)
    }
        
    public func show(animotion: Bool) {
        if animotion {
            view.backgroundColor = RGB(10, 10, 10, 0.5)
            UIView.animate(withDuration: 0.25) { self.containerView.transform = .identity }
        }else {
            containerView.transform = .identity
        }
    }
    
    public func hidden(animotion: Bool, complement: (()->())?) {
        if animotion {
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.transform = .init(translationX: 0, y: self.pickerHeight + 44)
            }) { flag in
                if flag {
                    self.removeFromParaentViewController()
                    complement?()
                }
            }
        }else {
            containerView.transform = .init(translationX: 0, y: self.pickerHeight + 44)
            
            self.removeFromParaentViewController()
            complement?()
        }
    }
    
    deinit {
        PrintLog("释放了：\(self)")
    }
}

extension TYPicker: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !containerView.frame.contains(gestureRecognizer.location(in: view))
    }
}
