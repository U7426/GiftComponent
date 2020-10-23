//
//  ViewController.swift
//  GiftComponent
//
//  Created by U7426 on 10/09/2020.
//  Copyright (c) 2020 U7426. All rights reserved.
//

import UIKit
import GiftComponent
import SnapKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        giftTest()

        // Do any additional setup after loading the view, typically from a nib.
    }

    func giftTest() {
        
        ///自定义配置样式（在giftShowView 初始化之前配置）
        let configuartion = Configuration.default
        configuartion.showDuration = 0.2
//        configuartion.senderTextColor = .yellow
//        configuartion.receiverTextColor = .red
        
        var lastView : GiftShowView<Gift>? = nil
        let views : [GiftShowView<Gift>] = [GiftShowView(),GiftShowView(),GiftShowView(),GiftShowView()]
        
        for (_,item) in views.enumerated() {
            view.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.bottom.equalTo(lastView == nil ? view.snp.centerY : lastView!.snp.top).offset(lastView == nil ? 100 : -50)
                make.right.equalTo(view.snp.left)
                make.width.equalTo(item.default_width)
                make.height.equalTo(item.default_height)
            }
            lastView = item
        }
        let manager = GiftManager<Gift>()
        manager.setupViews(views)
        
        ///模拟数据
        //用户头像
        let avatars = [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220538169&di=dd875399642305d7033ef1c2dfa92b52&imgtype=0&src=http%3A%2F%2Ft7.baidu.com%2Fit%2Fu%3D3646975693%2C3978456039%26fm%3D193",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220538169&di=52da5166ca278f9dc1c5c6064b30bb3c&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D3183183007%2C2073289373%26fm%3D193",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220538168&di=47af89ec67309ffbf68b32513202c45b&imgtype=0&src=http%3A%2F%2Ft8.baidu.com%2Fit%2Fu%3D595885617%2C884179174%26fm%3D193",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220538167&di=d577fb75f972e2a13201067dd3df4a5f&imgtype=0&src=http%3A%2F%2Ft9.baidu.com%2Fit%2Fu%3D2246033344%2C164411552%26fm%3D193",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220748424&di=0925e8075ac3c546f3197a869ed8ede2&imgtype=0&src=http%3A%2F%2Fwww.scxxg.net%2Fpublic%2Fuploads%2Fimages%2F20180731%2F1_201807311725395f81f.jpeg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220777092&di=91e9fe78948a0599d77dd7f370af8ab2&imgtype=0&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D297778481%2C2089397163%26fm%3D214%26gp%3D0.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594220739622&di=69fb45303e528d6945987de44b35bbc5&imgtype=0&src=http%3A%2F%2Fimage.namedq.com%2Fuploads%2F20190215%2F21%2F1550239006-CiQOglKPSt.jpg"
        ]
        //礼物列表
        let  array = NSArray(contentsOfFile: Bundle.main.path(forResource: "gift", ofType: "json")!)!
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            let model = Gift()
            
            let dic = array[Int(arc4random()) % array.count] as? Dictionary<String, Any>
            model.giftID = dic?["id"] as? Int
            model.giftIcon = dic?["img"] as? String
            
            model.avatar = avatars[Int(arc4random())%avatars.count]
            model.newValue = Int(arc4random()%50 + 1)
            model.giftID = Int(arc4random()%5 + 1)
            model.sender = String(arc4random()%2)
            model.receiver = String(arc4random()%2)
            model.multiple = [0,0,10,20,500][Int(arc4random())%5]
            manager.receive(value: model)
        }
    }
    
}

