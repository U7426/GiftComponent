//
//  GiftLuckyView.swift
//  KDGiftComponent
//
//  Created by 冯龙飞 on 2020/10/13.
//

import UIKit
import RxSwift
class GiftLuckyView<T: GiftShowType>: UIView {
    private let bigOffset: CGFloat = 15.0
    
    /// 🎉获得背景
    let congratsV = UIImageView()
    
    /// 射线
    let rayV = UIImageView()
    
    /// 盒子
    let boxV = UIImageView()
    
    /// win图片
    let winV = UIImageView()
    
    /// 倍大奖图片
    let timesCoinsV = UIImageView()
    
    /// 小倍数背景image
    let smallBackV = UIImageView()
    
    /// 大倍数背景view
    let timeBackView = UIView()
    
    /// 大倍数
    let timesL = UILabel()
    
    /// 小倍数
    let smallTimesL = UILabel()
    
    let hiddenSubject = PublishSubject<Bool>()
    
//    var timer : Timer?
    
    /// 数据
    var model : T?
    
    /// 最小停留时间
    let minStayTime = 1.5
    
    let smallTime = 2.0
    
    let bigTime = 3.0
    
    /// 🔒
    let lock = NSLock()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(congratsV)
        congratsV.image = Configuration.default.congrats
        congratsV.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(bigOffset)
        }
        
        insertSubview(rayV, at: 0)
        rayV.image = UIImage(named: "emissive-bg", in: Resources.bundle, compatibleWith: nil)
        rayV.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(bigOffset)
        }
        rayAddAnimtaion()
        
        insertSubview(boxV, at: 0)
        boxV.image = UIImage(named: "second-star", in: Resources.bundle, compatibleWith: nil)
        boxV.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(bigOffset)
        }
        
        congratsV.addSubview(timeBackView)
        timeBackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.congratsV)
            make.width.equalToSuperview().multipliedBy(Configuration.default.widthMutiply)
            make.height.equalToSuperview().multipliedBy(Configuration.default.heightMutiply)
            make.bottom.equalToSuperview().multipliedBy(Configuration.default.bottomMutiply)
        }
        
        timeBackView.addSubview(winV)
        winV.image = UIImage(named: "win", in: Resources.bundle, compatibleWith: nil)
        winV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        
        timeBackView.addSubview(timesL)
        timesL.snp.makeConstraints { (make) in
            make.left.equalTo(self.winV.snp.right).offset(2);
            make.centerY.equalToSuperview();
        }
        timesL.setLuckyTimes(num: 520)
        
        timeBackView.addSubview(timesCoinsV)
        timesCoinsV.image = UIImage(named: "times-coins!", in: Resources.bundle, compatibleWith: nil)
        timesCoinsV.snp.makeConstraints { (make) in
            make.left.equalTo(self.timesL.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        
        addSubview(smallBackV)
        smallBackV.image = Configuration.default.times_50
        smallBackV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(2)
        }
        
        smallBackV.addSubview(smallTimesL)
        smallTimesL.textAlignment = .center
        smallTimesL.font = Configuration.default.smallLuckyTextFont
        smallTimesL.textColor = Configuration.default.smallLuckyTextColor
        smallTimesL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(smallBackV.snp.right).multipliedBy(12.0 / 324).offset(10)
        }
    }
    
    func receive(_ model: T?) {
        let times  = model?.multiple ?? 0
        guard times > 0 else {
            return
        }
        guard model?.luckyShowing == false else {
            self.model = model
            return
        }
        self.model = model
        showCurrentTimes()
    }
    
    func showCurrentTimes() {
        let times  = model?.multiple ?? 0
        lock.lock()
        self.model?.multiple = 0
        lock.unlock()
        setupShow(isBig: times >= 500)
        if times >= 500 {
            bigAnimation()
            timesL.setLuckyTimes(num: times)
        }
        else {
            smallBackV.image = times >= 50 ?Configuration.default.times_50 : Configuration.default.times_10 
            smallAnimation()
            smallTimesL.setSamllLuckyTimes(num: times)
        }
        showNextWithBigTimes(times >= 500)
    }
    func showNextWithBigTimes(_ big : Bool) {
        var stayTime = 0.0
        let duration = 0.1
        let timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { timer in
            stayTime += duration
            guard stayTime >= self.minStayTime else {
                return
            }
            if self.model?.multiple ?? 0 > 0 {
                self.showCurrentTimes()
                timer.invalidate()
            }
            else {
                if stayTime >= (big ? self.smallTime : self.bigTime) {
                    timer.invalidate()
                    self.setupHidden()
                }
            }
        })
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    /// 设置大倍数和小倍数的隐藏
    /// - Parameter isBig: 是大倍数，还是小倍数
    func setupShow(isBig: Bool) {
        //改变显示状态
        self.model?.luckyShowing = true
        //大倍数
        self.isHidden = false
        boxV.isHidden = !isBig
        congratsV.isHidden = !isBig
        rayV.isHidden = !isBig
        timeBackView.isHidden = !isBig
        //小倍数
        smallBackV.isHidden = isBig
        //动画
        if isBig {
            let animation = self.rayV.layer.animation(forKey: "rayVAnimation")
            if animation == nil {
                rayAddAnimtaion()
            }
        }
    }
    
    /// 设置隐藏
    func setupHidden()  {
        self.isHidden = true
        self.model?.luckyShowing = false
    }
    /// 小倍数动画
    private func smallAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(rawValue: 0)) {
            self.transform = .identity
        }
    }
    
    ///大倍数动画
    private func bigAnimation() {
        self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(rawValue: 0)) {
            self.transform = .identity
        }
    }
    
    /// 转圈动画
    private func rayAddAnimtaion() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 3.0
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = MAXFLOAT
        rayV.layer.add(animation, forKey: "rayVAnimation")
    }
}

fileprivate extension UILabel {
    
    func setLuckyTimes(num: Int) {
        guard num > 0 else {
            return
        }
        let attributeString = NSMutableAttributedString.init(string: "")
        for index in 0..<String(num).count {
            let image = Configuration.default.luckyNums[String(num).slicing(from: index, length: 1)?.int ?? 0]
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: 0, width: image?.size.width ?? 40.0, height: image?.size.height ?? 40.0)
            attributeString.append(NSAttributedString(attachment: attachment))
        }
        self.attributedText = attributeString
    }
    
    func setSamllLuckyTimes(num: Int) {
        guard num > 0 else {
            return
        }
        let text = "赢得 \(num) 倍金币奖励"
        let attributeString = NSMutableAttributedString(string: text)
        let range =  NSRange(text.range(of: "\(num)")!, in: text)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: Configuration.default.smallLuckyNumTextColor, range:range)
        attributeString.addAttribute(NSAttributedStringKey.font, value: Configuration.default.smallLuckyNumTextFont, range: range)
        self.attributedText = attributeString
    }
}
