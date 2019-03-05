//
//  TEETabBarVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/2.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit


class TEETabBarVC: UITabBarController  {
    
//    @objc
//    public var addmifi = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.colorWithCustom(104, g: 141, b: 198)], for: UIControl.State.selected)
        gMainTC = self
    }
    
    // 1、获取数组下标
    // 2、修改改下表的图片，同时根据下表修改其他item的图片
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for i in 0 ..< validInt(self.tabBar.items?.count) {
            if item == self.tabBar.items![i] {
                print(i)
            }
        }
    }

}
