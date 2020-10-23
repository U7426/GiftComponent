//
//  GiftNumView.swift
//  KDGiftComponent
//
//  Created by 冯龙飞 on 2020/10/10.
//

import UIKit
class GiftNumView: UIView {
    
    /// 倍数图标
    let X = UIImageView(image: Configuration.default.multiply)
    
    /// 富文本展示数字
    let numL = UILabel()
    
    /// 滚动数字
    let numV = NumScrollView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        self.addSubview(X)
        X.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        
        self.addSubview(numL)
        numL.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(X.snp.right)
        }
        
        self.addSubview(numV)
        numV.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(X.snp.right)
        }
    }
    func setup(from: Int, to: Int) {
        let big = to - from >= 9
        showGig(yesOrNo: big)
        //显示滚动
        if big {
            self.numV.setup(from: from, to: to)
        }
        //显示跳动动画
        else{
            self.numL.setupGiftNum(num: to)
            self.numL.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(rawValue: 0)) {
                self.numL.transform = .identity
            } completion: { (_) in

            }
        }
    }
    
    /// 展示大的数字（大的用滚动，小的用富文本）
    /// - Parameter yesOrNo: 是否展示大的数字
    private func showGig(yesOrNo: Bool) {
        numL.isHidden = yesOrNo
        numV.isHidden = !yesOrNo
    }
}

extension UILabel {
    func setupGiftNum(num: Int) {
        let attributeString = NSMutableAttributedString.init(string: "")
        for index in 0..<String(num).count {
            let image = Configuration.default.nums[String(num).slicing(from: index, length: 1)?.int ?? 0]
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: 0, width: image?.size.width ?? 40.0, height: image?.size.height ?? 40.0)
            attributeString.append(NSAttributedString(attachment: attachment))
        }
        self.attributedText = attributeString
    }
}
