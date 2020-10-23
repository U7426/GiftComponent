//
//  GiftShowView.swift
//  Wonderful
//
//  Created by 冯龙飞 on 2020/10/9.
//

import UIKit
import Kingfisher
import SnapKit
public class GiftShowView<T:GiftShowType>: UIView {
    
    public var model : T?
    
    /// 默认宽度
    public let default_width : CGFloat = Configuration.default.giftShowViewWidth
    
    /// 默认高度
    public let default_height :CGFloat = Configuration.default.giftShowViewHeight
    
    let backgroundImageView = UIImageView()
    
    /// 头像
    let iconV = UIImageView()
    
    /// 发送者昵称
    let senderNameL = UILabel()
    
    /// 接收者昵称
    let receiverNameL = UILabel()
    
    /// 礼物图标
    let giftIconV = UIImageView()
    
    /// 数字
    let numV = GiftNumView()
    
    /// 中奖展示view
    let luckyView = GiftLuckyView<T>()
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: default_width, height: default_height))
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI()  {
        self.addSubview(backgroundImageView)
        backgroundImageView.image = Configuration.default.giftShowViewBackGroundImage
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(iconV)
        iconV.contentMode = .scaleAspectFill
        iconV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.left.equalToSuperview().offset(3)
            make.width.equalTo(iconV.snp.height)
        }
        
        self.addSubview(senderNameL)
        senderNameL.font = Configuration.default.senderTextFont
        senderNameL.textColor = Configuration.default.senderTextColor
        senderNameL.snp.makeConstraints { (make) in
            make.left.equalTo(iconV.snp.right).offset(6.0)
            make.top.equalToSuperview().offset(4.0)
            make.right.equalToSuperview().offset(-42)
        }
        senderNameL.text = "sender"
        
        self.addSubview(receiverNameL)
        receiverNameL.font = Configuration.default.receiverTextFont
        receiverNameL.textColor = Configuration.default.receiverTextColor
        receiverNameL.snp.makeConstraints { (make) in
            make.left.equalTo(iconV.snp.right).offset(6.0)
            make.bottom.equalToSuperview().offset(-4.0)
            make.right.equalTo(senderNameL)
        }
        receiverNameL.text = "to receiver"
        
        self.addSubview(giftIconV)
        giftIconV.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(giftIconV.snp.width)
        }
        
        self.addSubview(numV)
        numV.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        numV.isHidden = true
        
        self.addSubview(luckyView)
        luckyView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.bottom)
        }
    }
    
    /// 展示UI
    /// - Parameter model: 数据
    public func showUIWithData(_ model: T) {
        self.model = model
        display()
        show()
    }
    
    /// 更新UI
    /// - Parameter model: 数据
    public func updateUIWithData(_ model: T){
        self.model = model
        self.numV.setup(from: self.model?.oldValue ?? 0, to: self.model?.newValue ?? 0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.iconV.layer.cornerRadius = self.iconV.frame.size.width / 2
        self.iconV.layer.masksToBounds = true
    }
    
    private func display(){
        self.iconV.kf.setImage(with: self.model?.avatar?.url)
        self.giftIconV.kf.setImage(with: self.model?.giftIcon?.url)
    }
    
    /// 展示动画
    public func show() {
//        self.layoutIfNeeded()
        model?.showing = true
        numV.isHidden = true
        giftIconV.transform = CGAffineTransform(translationX: -self.frame.size.width + self.giftIconV.frame.size.width, y: 0)
        UIView.animate(withDuration: Configuration.default.showDuration, delay: 0.0, options: .curveEaseOut) {
            self.transform = .init(translationX: self.frame.size.width + 20, y: 0)
        } completion: { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseInOut) {
                self.giftIconV.transform = .identity
            } completion: { (_) in
                self.numV.isHidden = false
                self.numV.setup(from: self.model?.oldValue ?? 1, to: self.model?.newValue ?? 1)
                self.luckyView.receive(self.model)
            }
        }
    }
    
    /// 隐藏动画
    public func hidden(completed:@escaping ()->()) {
        UIView.animate(withDuration: Configuration.default.hiddenDuration, delay: 0.0, options: .curveEaseIn) {
            self.transform = self.transform.translatedBy(x: self.frame.size.width, y: 0)
            self.alpha = 0.0
        } completion: { (_) in
            self.alpha = 1.0
            self.transform = .identity
            self.model?.showing = false
            completed()
        }
    }
}
