//
//  CASetAvatarViewController.swift
//  CorporateAlbum
//
//  Created by 尹涛 on 2018/8/7.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import RxSwift

class CASetAvatarViewController: BaseViewController {

    @IBOutlet weak var avatarOutlet: UIButton!
    
    private var userInfo: UserInfoModel!
    
    private var picker: UIImagePickerController!
    
    private var viewModel: SetAvatarViewModel!
    
    @IBAction func tapActions(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            // 打开相册
            break
        case 101:
            // 发送修改头像请求
            openPhotoLibrary()
            break
        default:
            break
        }
    }
    
    override func setupUI() {
        picker = UIImagePickerController.init()
        UINavigationBar.appearance().tintColor = CA_MAIN_COLOR
        
        avatarOutlet.setImage(userInfo.PhotoUrl)
    }
    
    override func rxBind() {
        viewModel = SetAvatarViewModel()
        
        viewModel.popSubject
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        userInfo = parameters!["user"] as! UserInfoModel
    }

}

extension CASetAvatarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //打开相册
    fileprivate func openPhotoLibrary() {
        let souceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(souceType) == true {
            picker.sourceType = souceType
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    //MARK:
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            if let editImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                //裁剪后的图片
                self.viewModel.submitAvatarSetSubject.onNext(editImage)
            }
        }
    }
}
