//
//  Utils.swift
//  Swift_TabBar
//
//  Created by 李金奎 on 2018/5/18.
//  Copyright © 2018年 李金奎. All rights reserved.
//

import UIKit

// 设备屏幕宽
public let ScreenW = UIScreen.main.bounds.width
// 设备屏幕高
public let ScreenH = UIScreen.main.bounds.height

// tabbar突出高度度 20
public let standOutHeight: CGFloat = 12

class TabUtils: NSObject {

    // 画tabBar背景
    class func drawTabBarImageView() -> UIImageView{
        // 标签栏的高度
        let TabBarHeight: CGFloat = self.getTabBarHeight()
        print("tabBarHeight: \(TabBarHeight)")
        let radius: CGFloat = 30//圆半径
        // 突出高度
        let allFloat: CGFloat = (pow(radius, 2) - pow(radius - standOutHeight, 2))
        let ww: CGFloat = CGFloat(sqrtf(Float(allFloat)))
        let angleH: CGFloat = 0.5 * ((radius - standOutHeight)/radius)
        let startAngle: CGFloat = (1 + angleH) * CGFloat(Double.pi)
        let endAngle: CGFloat = (2 - angleH) * CGFloat(Double.pi)
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: -standOutHeight, width: ScreenW, height: TabBarHeight + standOutHeight))
        let size = imageView.frame.size
        let layer = CAShapeLayer.init()
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: (size.width/2) - ww, y: standOutHeight))
        // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
        path.addArc(withCenter: CGPoint(x: (size.width/2), y: radius), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //开始画弧以外的部分
        path.addLine(to: CGPoint(x: size.width/2 + ww, y: standOutHeight))
        path.addLine(to: CGPoint(x: size.width, y: standOutHeight))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: standOutHeight))
        path.addLine(to: CGPoint(x: size.width/2 - ww, y: standOutHeight))
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.init(white: 0.765, alpha: 1.0).cgColor
        layer.lineWidth = 0.5
        imageView.layer.addSublayer(layer)
        return imageView
    }
    // 获取Tab的高，主要是X和其他设备不同
    class func getTabBarHeight() -> (CGFloat){
        let tabBarController = UITabBarController()
        let height = tabBarController.tabBar.bounds.height
        if (UIScreen.main.bounds.height == 812) && (UIScreen.main.bounds.width == 375){
            return 83
        } else {
            return height
        }
    }
}

