//
//  AlbumViewModel.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/7/27.
//  Copyright © 2018年 yintao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumViewModel: RefreshVM<AlbumBookModel>, VMNavigation {
    
    // 0 - 全部，1 - 收藏
    let dataTypeObser = Variable(0)
    
    var collectePublic = PublishSubject<AlbumBookModel>()
    
    private var searchText: String = ""
    
    init(searchTextObser: Driver<String>) {
        super.init()
//        //        1.创建对象
//        let person = Person()
//        person.age = 21
//        person.name = "郭鸿"
//        person.height = 178.00
        
        //        2.获取路径
//        let pathStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
//        let path = pathStr.strings(byAppendingPaths: ["user.plist"]).last!
        
        //        3.归档
//        NSKeyedArchiver.archiveRootObject(person, toFile: path)
//        
//        //        4.解档
//        let person2 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! Person
//        print(person2.age, person2.name!, person2.height)

        
        //        1.创建对象
//        let t = TestModel()
//        t.age = 21
//        t.name = "郭鸿"
//        t.height = 178
//        
//        //        3.归档
//        NSKeyedArchiver.archiveRootObject(t, toFile: path)
//        
//        //        4.解档
//        let t2 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! TestModel
//        print(t2.age, t2.name, t2.height)

        searchTextObser.drive(onNext: { [unowned self] in
            self.searchText = $0
        })
            .disposed(by: disposeBag)
        
        
        collectePublic
            .filter({ [unowned self] _ -> Bool in
                if CACoreLogic.isUserLogin() == true {
                    return true
                }
                self.hud.failureHidden("您还没有登录~")
                return false
            })
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.collectBook(model: $0) })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.Album.HomeAlbumRewardChanged, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        if dataTypeObser.value == 0 {
            let request = CARProvider.rx.request(.book(search: searchText,
                                                       skip: pageModel.skip,
                                                       limit: pageModel.pageSize))
                .map(models: AlbumBookModel.self)
            
            if datasource.value.count > 0 {
                request.subscribe(onSuccess: { [unowned self] datas in
                    self.updateRefresh(refresh, datas, datas.count)
                    AlbumBookModel.insert(datas: datas)
                }) { [unowned self] error in
                    self.revertCurrentPageAndRefreshStatus()
                    }
                    .disposed(by: disposeBag)
            }else {
                Observable<[AlbumBookModel]>.selectedDB(type: AlbumBookModel.self, tbName: AlbumBookTB)
                    .concat(request.asObservable())
                    .subscribe(onNext: { [unowned self] datas in
                        self.updateRefresh(refresh, datas, datas.count)
                        AlbumBookModel.insert(datas: datas)
                        }, onError: { [unowned self] error in
                            self.revertCurrentPageAndRefreshStatus()
                    })
                    .disposed(by: disposeBag)
            }
        }else {
            CARProvider.rx.request(.favoriteBook(search: searchText, skip: pageModel.skip, limit: pageModel.pageSize))
                .map(models: AlbumBookModel.self)
                .subscribe(onSuccess: { model in
                    self.updateRefresh(refresh, model, model.count)
                }) { [unowned self] error in
                    self.revertCurrentPageAndRefreshStatus()
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func collectBook(model: AlbumBookModel) {
        CARProvider.rx.request(.addBook(siteName: model.SiteName, bookId: model.Id))
            .mapResponseStatus()
            .subscribe(onSuccess: { [unowned self] model in
                if model.error == 0 {
                    self.hud.successHidden("收藏成功！")
                }else {
                    self.hud.failureHidden(model.message)
                }
            }) { [unowned self] error in
                self.hud.failureHidden(self.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}
