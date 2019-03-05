//
//  LHBootPageVC.swift
//  LANHU
//
//  Created by 柯木超 on 2018/11/2.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEEBootPageVC: UIViewController {
    var numOfPages = 3
    
//    var tarbarConfigArr:[Dictionary<String,String>]! //标签栏配置数组，从Plist文件中读取
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = self.view.bounds
        //scrollView的初始化
        let scroll = UIScrollView()
        scroll.frame = self.view.bounds
        scroll.contentSize = CGSize(width:frame.size.width * CGFloat(numOfPages),
                                    height:frame.size.height)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        for i in 0 ..< numOfPages {
            let img1 = UIImageView(image: UIImage(named:"laun\(i+1)"))
            img1.frame = CGRect(x:frame.size.width*CGFloat(i), y:CGFloat(0),
                                width:frame.size.width, height:frame.size.height)
            scroll.addSubview(img1)
        }
        
        let button = UIButton()
        button.frame = CGRect(x:frame.size.width * validCGFloat((numOfPages - 1)) + 100, y:frame.size.height*0.85,
                              width:frame.size.width - 200 , height:frame.size.height/8)
        scroll.addSubview(button)
        button.addTarget(self, action:#selector(tapped), for:.touchUpInside)

        let button1 = UIButton()
        button1.frame = CGRect(x: 100, y:frame.size.height*0.85,
                              width:frame.size.width - 200 , height:frame.size.height/8)
        scroll.addSubview(button1)
        button1.addTarget(self, action:#selector(tapped), for:.touchUpInside)
        
        self.view.addSubview(scroll)
        
        self.tapped()

    }

    @objc func tapped() {
        let tabBarController = UIStoryboard(name: kStoryBoard_Main, bundle: nil).instantiateViewController(withIdentifier: "\(TEETabBarVC.classForCoder())") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        
    }
}
