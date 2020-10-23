//
//  Gift.swift
//  Wonderful
//
//  Created by 冯龙飞 on 2020/10/9.
//

import Foundation
import RxSwift
public class Gift: GiftShowType {
    
    /// 头像
    public var avatar: String?
    
    /// 发送者昵称
    public var senderName: String?
    
    /// 接受者昵称
    public var receiverName: String?
    
    /// 发送者
    public var sender : String?
    
    /// 接收者
    public var receiver : String?
    
    /// 礼物id
    public var giftID : Int?
    
    public var giftIcon : String?
    
    /// 旧值
    public var oldValue : Int = 1
    
    /// 收到新的礼物数量
    public var newValue : Int = 1
    
    /// 是否正在展示
    public var showing : Bool = false
    
    /// 中奖是否正在展示
    public var luckyShowing: Bool = false
    
    /// 是否可以更新
    public var canUpdate: Bool = true
    
    /// 隐藏信号（该礼物展示需要隐藏时，会发出信号）
    public var hiddenSubject = PublishSubject<String>()
    
    public var multiple : Int = 0
    
    public var disposeBag = DisposeBag()
    
    public init() {
        
    }
}
