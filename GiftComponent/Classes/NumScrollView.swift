//
//  NumScrollItemView.swift
//  KDGiftComponent
//
//  Created by 冯龙飞 on 2020/10/10.
//

import UIKit
class NumScrollView: UIView {
    /// 单个的宽度
    let itemWidth : CGFloat = 21
    let itemHeiht : CGFloat = 36
    ///当前创建单个滚动视图的个数
    var count : Int = 0
    let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis  = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(from: Int, to: Int) {
        assert(to >= from, "结束数字不小于开始数值")
        let fromString = String(from)
        let toString = String(to)
        let nowCount :Int = count
        //超过复用 个数，创建所需要的个数，并添加
        if toString.count > nowCount {
            for index in nowCount..<toString.count {
                let item = NumScrollItemView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemHeiht), style: .plain)
                item.tag = 100 + index
                stackView.addArrangedSubview(item)
                item.snp.makeConstraints { (make) in
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(itemHeiht)
                }
                count += 1
            }
        }
        //隐藏多余的位数
        for index in toString.count..<count {
            let itemView = viewWithTag(100 + index) as? NumScrollItemView
            itemView?.isHidden = true
        }
        //滚动数字
        for index in 0..<toString.count {
            var fromIetmNum  = -1
            var toItemNum = 0
            if index < fromString.count {
                fromIetmNum = fromString.slicing(from: index, length: 1)?.int ?? -1
            }
            toItemNum = toString.slicing(from: index, length: 1)?.int ?? 0
            let itemView = viewWithTag(100 + index) as? NumScrollItemView
            itemView?.isHidden = false
            itemView?.setup(from: fromIetmNum, to: toItemNum)
        }
    }
}

class NumScrollItemView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.scrollsToTop = false
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.register(NumCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(from: Int, to: Int) {
        if from < 0 {
            self.setContentOffset(CGPoint(x: 0, y: -40), animated: false)
        }
        else{
            self.scrollToRow(at: IndexPath(row: from, section: 0), at: .none, animated: false)
        }
        guard from != to else {
            return
        }
        if from < to {
            self.scrollToRow(at: IndexPath(row: to, section: 0), at: .bottom, animated: true)
        }
        else {
            self.scrollToRow(at: IndexPath(row: 10 + to, section: 0), at: .bottom, animated: true)
        }
    }
}
extension NumScrollItemView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NumCell
        let num = Configuration.default.nums[indexPath.row >= 10 ? indexPath.row - 10 : indexPath.row]
        cell.setupNum(num:num)
        return cell
    }
}

class NumCell: UITableViewCell {
    let iconV = UIImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(iconV)
        iconV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNum(num: UIImage?) {
        guard let num = num else {
            return
        }
        iconV.image = num
    }
}
