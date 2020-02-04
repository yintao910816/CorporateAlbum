//
//  String+Operation.swift
//  CorporateAlbum
//
//  Created by yintao on 2020/2/4.
//  Copyright © 2020 yintao. All rights reserved.
//

import Foundation

extension String {
    
    /// 截取从头到i位置
    public func substring(to:Int) -> String{
        if self.count < to { return self }
        return self[0..<to]
    }
    
    /// 截取 从i到尾部
    public func substring(from:Int) -> String{
        if from < 0 { return self }
        return self[from..<self.count]
    }

    /**
     * 字符串截取 - 从任意位置开始截取
     * from - 开始位置
     * to     - 结束位置
     */
    public func substring(from: Int, to: Int) ->String {
        if from < 0 { return self }
        if self.count < to { return self }
        return self[from..<to]
    }

    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
}
