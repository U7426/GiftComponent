//
//  GiftManager.swift
//  Wonderful
//
//  Created by 冯龙飞 on 2020/9/28.
//

import Foundation
import RxSwift
public class GiftManager<T: GiftType> {
    
    /// 最大弹道数量
    public var maxCount = Configuration.default.maxCount
    
    /// 更新UI
    public var updateUI : ((T)->())?
    
    /// 展示
    public var show : ((T)->())?
    
    /// 隐藏
    public var hidden : ((String)->())?
    
    
    /// 展示中数据管理
    private let showingMap  = Map()
    
    ///预备数据管理
    private let prepareMap  = Map()
    
    /// 礼物展示视图字典(快速查找视图使用)
    private var viewsMap : [String: Any] = Dictionary()
    
    /// 串行队列
    private let queue = DispatchQueue(label: "com.wonderful.gift")
    
    /// 线程安全锁
    private lazy var lock : pthread_mutex_t = {
        var t = pthread_mutex_t()
        pthread_mutex_init(&t, nil)
        return t
    }()
    
    public init() {
        
    }
    
    /// 收到礼物
    /// - Parameter gift: 礼物
    public func receive(value: T) {
        queue.async {
            let node = self.showingMap.dic[value.key()]
            if let node = node, node.value?.canUpdate == true {
                self.update(node, value: value)//更新数据
            }
            else {
                self.add(value)//添加数据
            }            
        }
    }
    
    /// 下一个
    /// - Parameter currentKey: 当前key
     public func next(_ currentKey:String)  {
        safe {
            self.removeShowingForKey(currentKey)
            if let node = self.prepareMap.head {
                _ = self.prepareMap.removeHeadNode()
                self.showingMap.insertNodeAtTail(node)
                DispatchQueue.main.async {
                    self.show?(node.value as! T)
                }
                node.value?.hiddenSubject.onNext(node.value?.key() ?? "")
            }
        }
    }
    
    /// 清除所有
    public func removeAll() {
        safe {
            self.showingMap.removeAll()
            self.prepareMap.removeAll()
            self.viewsMap.removeAll()
        }
    }
    
    /// 设置展示的views
    /// - Parameter views: 展示视图
    public func setupViews<T: GiftShowType>(_ views: [GiftShowView<T>]) {
        self.show = {[weak self] gift  in
            var showView : GiftShowView<T>?
            for item in views {
                if item.model?.showing == false || item.model == nil {
                    showView = item
                    self?.viewsMap[gift.key()] = item
                    break
                }
            }
            DispatchQueue.main.async {
                showView?.showUIWithData(gift as! T)
            }
        }
        self.updateUI = {[weak self] gift in
            let showView : GiftShowView<T>? = self?.viewsMap[gift.key()] as? GiftShowView<T>
            DispatchQueue.main.async {
                showView?.updateUIWithData(gift as! T)
            }
        }
        self.hidden = {[weak self] key in
            let showView : GiftShowView<T>? = self?.viewsMap[key] as? GiftShowView<T>
            showView?.hidden(completed: {
                self?.viewsMap.removeValue(forKey: key)
                self?.next(key)
            })
        }
    }
    
    //MARK: -- private
    
    /// 添加礼物
    /// - Parameter value: 礼物
    private func add(_ value: T) {
        let node = Node()
        node.key = value.key()
        node.value = value
        value
            .hiddenSubject
            .debounce(DispatchTimeInterval.seconds(4), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] key in
                node.value?.canUpdate = false
                self?.hidden?(key)
            })
            .disposed(by: value.disposeBag)

        safe {
            if self.showingMap.dic.keys.count < self.maxCount {
                self.showingMap.insertNodeAtTail(node)
                DispatchQueue.main.async {
                    self.show?(value)                    
                }
                value.hiddenSubject.onNext(value.key())
            }
            else{
                if let theNode =  self.prepareMap.dic[value.key()] {
                    theNode.update(value)
                }
                else{
                    self.prepareMap.insertNodeAtTail(node)
                }
            }
        }
    }
    
    /// 更新正在展示的礼物
    /// - Parameters:
    ///   - node: 节点
    ///   - value: 节点中的数据
    private func update(_ node: Node, value: T) {
        node.update(value)
        DispatchQueue.main.async {
            self.updateUI?(node.value as! T)
        }
        node.value?.hiddenSubject.onNext(node.value?.key() ?? "")
    }
    
    
    /// 清除某一个
    /// - Parameter key: key
    func removeShowingForKey(_ key : String) {
        safe {
            let node = self.showingMap.dic[key]
            self.showingMap.removeNode(node)
        }
    }
    
    private func safe(_ action: (()->())?) {
        pthread_mutex_trylock(&lock)
        action?()
        pthread_mutex_unlock(&lock)
    }
    
    deinit {
        pthread_mutex_destroy(&lock)
    }
}

extension GiftManager {
    
    class Map {
        var dic = [String:Node]()
        var head : Node?
        var tail : Node?
        
        /// 尾部插入节点
        /// - Parameter node: 节点
        func insertNodeAtTail(_ node: Node) {
            dic[node.key] = node
            guard let tail = tail else {
                self.head = node
                self.tail = node
                return
            }
            tail.next = node
            node.prev = tail
            self.tail = node
        }
        
        /// 节点移动到头部
        /// - Parameter node: 节点
        func bringNodeToHeader(_ node : Node) {
            guard head === node else {
                return
            }
            if tail === node {
                tail = node.prev
                tail?.next = nil
            }
            node.next = head
            node.prev = nil
            head?.prev = node
            head = node
        }
        
        /// 删除节点
        /// - Parameter node: 节点
        func removeNode(_ node: Node?) {
            guard let node = node else {
                return
            }
            dic.removeValue(forKey: node.key)
            if let next = node.next { next.prev = node.prev }
            if let prev = node.prev { prev.next = node.next }
            if head === node {  head = node.next }
            if tail === node { tail = node.prev }
        }
        
        /// 删除头节点
        func removeHeadNode() -> Node? {
            guard let node = head else {
                return nil
            }
            removeNode(node)
            return node
        }
        
        /// 删除所有节点
        func removeAll() {
            dic.removeAll()
            head = nil
            tail = nil
        }
    }
    
    class Node {
        var prev : Node?
        var next : Node?
        var key : String!
        var value : GiftType?
        func update(_ node: GiftType) {
            //礼物数量更新
            let newValue = self.value?.newValue ?? 1
            self.value?.oldValue = newValue
            self.value?.newValue = newValue + node.newValue
            //中奖倍数更新
            let luckyNum = self.value?.multiple ?? 0
            self.value?.multiple = luckyNum + node.multiple
        }
    }
}
