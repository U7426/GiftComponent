//
//  GiftType.swift
//  Wonderful
//
//  Created by 冯龙飞 on 2020/10/9.
//

import Foundation
import RxSwift
public protocol  GiftType {
    
    /// 当前展示值
    var oldValue : Int {set get}
    
    /// 收到新的礼物后的值
    var newValue : Int {set get}
    
    /// 中奖倍数
    var multiple : Int {set get}
    
    /// 是否可以更新(在开始移除动画的时候，该礼物是不能被更新的)
    var canUpdate : Bool {set get}
    
    /// 隐藏信号（该礼物展示需要隐藏时，会发出信号）
    var hiddenSubject : PublishSubject<String> {set get}
    
    var disposeBag : DisposeBag {set get}
    
    /// key
    func key() -> String
}

public protocol GiftShowType : GiftType {
    /// 发送者id
    var sender : String? {set get}
    
    /// 接收者id
    var receiver : String? {set get}
    
    /// 礼物id
    var giftID : Int? {set get}
    
    var giftIcon : String? {set get}
    
    /// 头像
    var avatar : String? {set get}
    
    /// 发送者昵称
    var senderName : String? {set get}
    
    /// 接受者昵称
    var receiverName : String? {set get}
    
    /// 是否正在展示
    var showing : Bool {set get}
    
    /// 中奖是否正在展示
    var luckyShowing : Bool {set get}
    
    
}

public extension GiftShowType {
    func key() -> String {
        return "send:\(sender ?? "")_receive:\(receiver ?? "")_giftID:\(giftID ?? 0)"
    }
}

