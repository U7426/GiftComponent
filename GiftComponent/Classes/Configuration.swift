//
//  Configuration.swift
//  KDGiftComponent
//
//  Created by 冯龙飞 on 2020/10/14.
//

import Foundation
public class Configuration {
    public static let `default` = Configuration()
    
    /// 最大弹道数
    public var maxCount = 4
    
    //MARK: -- showView
    
    /// 礼物展示view背景图
    public var giftShowViewBackGroundImage = UIImage(named: "room_bg_gift_area", in: Resources.bundle, compatibleWith: nil)
    
    /// 礼物展示view宽度
    public var giftShowViewWidth : CGFloat = 160.0
    
    ///礼物展示view高度
    public var giftShowViewHeight : CGFloat = 40.0
    
    /// 礼物动画展示Duration
    public var showDuration : TimeInterval = 0.2
    
    /// 礼物动画隐藏Duration
    public var hiddenDuration : TimeInterval = 0.2
    
    
    /// 发送者字体颜色
    public var senderTextColor = UIColor.white
    
    /// 发送者字体
    public var senderTextFont = UIFont(name: "PingFangSC-Medium", size: 12)
    
    /// 接收者字体颜色
    public var receiverTextColor = UIColor.white
    
    /// 接收者字体
    public var receiverTextFont = UIFont(name: "PingFangSC-Medium", size: 12)
    
    
    //MARK: -- 数字图片
    /// 数字乘图片
    public var multiply : UIImage? = UIImage(named: "Ani-x", in: Resources.bundle, compatibleWith: nil)
    
    /// 数字图片数组
    public var nums : [UIImage?] = [
        UIImage(named: "Ani-0", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-1", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-2", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-3", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-4", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-5", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-6", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-7", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-8", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "Ani-9", in: Resources.bundle, compatibleWith: nil)
    ]
    //MARK: -- lucky
    
    /// 500倍中奖背景图片
    public var congrats : UIImage? = UIImage(named: "congrats500-frontbg", in: Resources.bundle, compatibleWith: nil)
    
    /// 大于等于50倍，背景图
    public var times_50 = UIImage(named: "Congrats-bg50", in: Resources.bundle, compatibleWith: nil)
    
    /// 小于50倍，背景图
    public var times_10 = UIImage(named: "Congrats-bg10", in: Resources.bundle, compatibleWith: nil)
    
    
    /// 大于500倍中奖数字
    public var luckyNums : [UIImage?] = [
        UIImage(named: "0times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "1times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "2times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "3times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "4times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "5times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "6times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "7times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "8times", in: Resources.bundle, compatibleWith: nil),
        UIImage(named: "9times", in: Resources.bundle, compatibleWith: nil)
    ]
    
    ///小倍数默认文字颜色
    public var smallLuckyTextColor = UIColor.white
    
    ///小倍数默认文字字体
    public var smallLuckyTextFont = UIFont(name: "PingFangSC-Medium", size: 12.0)
    
    ///小倍数数字文字颜色
    public var smallLuckyNumTextColor = UIColor(hex: 0xfff800)!
    
    ///小倍数数字文字字体
    public var smallLuckyNumTextFont = UIFont(name: "AmericanTypewriter-CondensedBold", size: 18)!
    
    /// 500倍大奖中奖文字宽度占500倍中奖背景的比列
    public var widthMutiply : CGFloat = 338.0  / 437
    
    /// 500倍大奖中奖文字高度占500倍中奖背景的比列
    public var heightMutiply : CGFloat = 49.0  / 257
    
    /// 500倍大奖中奖文字底部到500倍中奖背景顶部的比列
    public var bottomMutiply : CGFloat = 225.0 / 315
    
    
}
