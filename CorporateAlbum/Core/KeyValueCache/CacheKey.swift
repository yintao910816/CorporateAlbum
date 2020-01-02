//
//  CacheKey.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

/**
 * 是否加载引导界面
 *
 * vLaunch 如果需要显示引导页，把该值+1
 */
let kLoadLaunch    = "load_launch"
let vLaunch   = "1"

// App接口调用令牌
let kToken            = "app_token"

// 当前用户类型
let kUType            = "user_type"
// 当前登录用户id
let kUid              = "user_id"
// 从扫码界面进入，返回root
let kIsPopToRoot       = "pop_root"
