//
//  CAAlbumInfoViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/1.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxSwift

class CAAlbumInfoViewController: BaseViewController {

    @IBOutlet weak var bottomToolBar: UIView!
    @IBOutlet weak var topToolBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iconOutlet: UIButton!
    
    @IBOutlet weak var botomBarHeightCns: NSLayoutConstraint!
    @IBOutlet weak var botomBarCns: NSLayoutConstraint!

    @IBOutlet weak var topBarTopCns: NSLayoutConstraint!
    @IBOutlet weak var topBarHeightCns: NSLayoutConstraint!
    
    private var viewModel: AlbumInfoViewModel!
    
    private var pageViewController:UIPageViewController!
        
    private var tapGes: UITapGestureRecognizer!
    
    private var currentPage: Int = 0
    
    private var coinView: CoinView!
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NotificationName.Album.HomeAlbumRewardChanged, object: nil)
        NotificationCenter.default.post(name: NotificationName.Album.SiteRewardChanged, object: nil)
        NotificationCenter.default.post(name: NotificationName.Album.SiteAlbumRewardChanged, object: nil)
    }
    
    @IBAction func saveAlbum(_ sender: Any) {
        guard let pageCtrl = pageViewController.viewControllers?.first as? AlbumPageViewController else {
                NoticesCenter.alert(title: "提示", message: "保存失败！")
                return
        }
        
        if let image = pageCtrl.imageView.image {
            DBQueue.share.save(toPhotosAlbum: image) { (ret, message) in
                DispatchQueue.main.async {
                    if ret == true {
                        NoticesCenter.alert(title: "提示", message: "保存成功！")
                    }else {
                        NoticesCenter.alert(title: "提示", message: "保存失败 \(message)")
                    }
                }
            }
        }

    }
    
    @IBAction func back(_ sender: Any) {
        if userDefault.isPopToRoot == true {
            userDefault.isPopToRoot = false
            navigationController?.popToRootViewController(animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private lazy var rewardsView: CARewardsAlertView = {
        let alertView = CARewardsAlertView.init(frame: self.view.bounds)
        view.addSubview(alertView)
        view.bringSubviewToFront(alertView)
        alertView.getRewardsCallBack = { [unowned self] in
            self.viewModel.postRewordsSubject.onNext($0)
        }
        return alertView
    }()

    
    @objc private func toolBarAnimotion() {
        UIApplication.shared.isStatusBarHidden = self.topBarTopCns.constant == 0

        if botomBarCns.constant == 0 {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.botomBarCns.constant = -(100 + LayoutSize.bottomVirtualArea)
                self?.topBarTopCns.constant = -(64 + LayoutSize.topVirtualArea)
                self?.view.layoutIfNeeded()
            }
        }else {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.botomBarCns.constant = 0
                self?.topBarTopCns.constant = 0
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func setupUI() {
        topBarHeightCns.constant = 64 + LayoutSize.fitTopArea
        botomBarHeightCns.constant = 100 + LayoutSize.bottomVirtualArea
        
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(toolBarAnimotion))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: (100 - 14) * 0.75, height: 100 - 14)
        layout.sectionInset = .init(top: 7, left: 7, bottom: 7, right: 7)
        layout.minimumInteritemSpacing = 15
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: "AlbumPagesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumPagesCellID")
        
        setupPageCtrl()
        
        view.bringSubviewToFront(topToolBar)
        view.bringSubviewToFront(bottomToolBar)
    }
    
    private func setupPageCtrl() {
        let options = [UIPageViewController.OptionsKey.spineLocation:NSNumber(value: UIPageViewController.SpineLocation.min.rawValue as Int)]
        
        pageViewController = UIPageViewController(transitionStyle:UIPageViewController.TransitionStyle.pageCurl,navigationOrientation:UIPageViewController.NavigationOrientation.horizontal,options: options)
        
        pageViewController.delegate = self
        
        pageViewController.dataSource = self
        
        view.insertSubview(pageViewController.view, belowSubview: bottomToolBar)
        addChildViewController(pageViewController)
    }
    
    override func rxBind() {
        
        viewModel.shouldShowAlertSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.rewardsView.model = $0
                self?.rewardsView.excuteAnimotion()
            })
            .disposed(by: disposeBag)
        
        viewModel.colDatasourceObser.asDriver()
            .map({ [weak self] data -> [AlbumPageModel] in
                if data.0.count > 0 && data.1 == true {
                    self?.pageViewController.setViewControllers([AlbumPageViewController.init(albumPageModel: data.0.first!)], direction: .forward, animated: true, completion: nil)
                    
                    self?.viewModel.pageSelctedAward.onNext(data.0.first!)
                }
                return data.0
            })
            .drive(collectionView.rx.items(cellIdentifier: "AlbumPagesCellID", cellType: AlbumPagesCell.self)) { (row, model, cell) in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        viewModel.iconObser
            .bind(to: iconOutlet.rx.image)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                if self.currentPage != indexPath.row {
                    let direction: UIPageViewController.NavigationDirection = self.currentPage > indexPath.row ? .reverse : .forward
                    self.currentPage = indexPath.row
                    self.pageViewController.setViewControllers([AlbumPageViewController.init(albumPageModel: self.viewModel.colDatasourceObser.value.0[self.currentPage])],
                                                               direction: direction,
                                                               animated: true,
                                                               completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(AlbumPageModel.self)
            .bind(to: viewModel.pageSelctedAward)
            .disposed(by: disposeBag)

        viewModel.dropCoinObser.subscribe(onNext: { [weak self] (coinCount, pageModel) in
            let curPageModel = self?.viewModel.colDatasourceObser.value.0[self?.currentPage ?? 0]
            if let rect = self?.view.bounds, curPageModel?.Id == pageModel.Id {
                self?.coinView = CoinView.init(frame: rect, withNum: Int32(coinCount))
                self?.coinView.coindelegate = self
                self?.view.addSubview(self!.coinView)
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(true)
    }
    
    override func prepare(parameters: [String : Any]?) {
        let bookId = parameters!["bookId"] as! String
        viewModel = AlbumInfoViewModel.init(bookId: bookId)
    }
}

extension CAAlbumInfoViewController: coinViewDelegate {
    
    func coinAnimationFinished() {
        coinView.coindelegate = nil
        coinView.removeFromSuperview()
        coinView = nil
    }
}

extension CAAlbumInfoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: view)
        if botomBarCns.constant == 0 && (point.y <= topToolBar.height || point.y >= (view.height - bottomToolBar.height)) {
            // 工具栏未隐藏
            return false
        }
        return true
    }
}

extension CAAlbumInfoViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
     
        if finished == true {
            view.isUserInteractionEnabled = true
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        view.isUserInteractionEnabled = false

    }
    
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentPage - 1 >= 0 {
            if botomBarCns.constant == 0 {
                toolBarAnimotion()
            }
            
            currentPage -= 1
            viewModel.pageSelctedAward.onNext(viewModel.colDatasourceObser.value.0[currentPage])
            let pageVC = AlbumPageViewController.init(albumPageModel: viewModel.colDatasourceObser.value.0[currentPage])
            return pageVC
        }
        return nil
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentPage + 1 < viewModel.colDatasourceObser.value.0.count {
            if botomBarCns.constant == 0 {
                toolBarAnimotion()
            }

            currentPage += 1
            viewModel.pageSelctedAward.onNext(viewModel.colDatasourceObser.value.0[currentPage])
            let pageVC = AlbumPageViewController.init(albumPageModel: viewModel.colDatasourceObser.value.0[currentPage])
            return pageVC
        }
        return nil
    }

}
