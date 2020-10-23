# GiftComponent

[![CI Status](https://img.shields.io/travis/U7426/GiftComponent.svg?style=flat)](https://travis-ci.org/U7426/GiftComponent)
[![Version](https://img.shields.io/cocoapods/v/GiftComponent.svg?style=flat)](https://cocoapods.org/pods/GiftComponent)
[![License](https://img.shields.io/cocoapods/l/GiftComponent.svg?style=flat)](https://cocoapods.org/pods/GiftComponent)
[![Platform](https://img.shields.io/cocoapods/p/GiftComponent.svg?style=flat)](https://cocoapods.org/pods/GiftComponent)

## description
  Manager 使用 Map + 双向链表 数据结构管理，类似LRU缓存淘汰算法。  
  所有逻辑处理在 Manger中， 展示视图只需要在manager 回调时 展示、更新、隐藏，逻辑处理 和  UI 没有耦合。

## Example
```swift
        ///自定义配置样式（在ShowView 初始化之前配置）
        let configuartion = Configuration.default
        configuartion.showDuration = 0.2
        ...
        
        ///创建manager
        let manager = GiftManager<Gift>() //可自定义Model，遵守GiftShowType 协议。这里以提供的默认的 Gift 为例
        manager.setupViews(views)
        
        ///将接收到的数据添加到manager
        let model = Gift() 
        model.giftID = ...
        manager.receive(value: model)
        
```

## Installation

GiftComponent is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GiftComponent'
```

## Author

U7426, u7426fenglongfei@163.com

## License

GiftComponent is available under the MIT license. See the LICENSE file for more info.
