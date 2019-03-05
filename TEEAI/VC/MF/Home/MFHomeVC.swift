//
//  MFHomeVC.swift
//  MIFI
//
//  Created by 柯木超 on 2018/12/4.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class MFHomeVC: ABCBaseVC {
    
    @IBOutlet weak var useFlow: ZZCircleProgress!
    @IBOutlet weak var powerView: ZZCircleProgress!
    
    enum SegueIdentifier: String {
        case toSearchDevice         = "toSearchDeviceVC"
        case toDeviceRoot           = "toDeviceRootVC"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgressView()
        setbuProgressData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.navigationController?.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.navigationController?.title = "随身路由器"

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func backAction() {
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    func setProgressView() {
        //是否显示圆点
        self.useFlow.showPoint = true
        //是否显示进度文本
        self.useFlow.showProgressText = false
        //进度是否从头开始
        self.useFlow.increaseFromLast = true
        //起点
        self.useFlow.startAngle = -90
        self.useFlow.strokeWidth = 5
        
        //是否显示圆点
        self.powerView.showPoint = true
        //是否显示进度文本
        self.powerView.showProgressText = true
        //进度是否从头开始
        self.powerView.increaseFromLast = true
        //起点
        self.powerView.startAngle = -90
        self.powerView.strokeWidth = 5
    }
    
    func setbuProgressData(){
        self.useFlow.progress = 0.5
        self.useFlow.pathFillColor = UIColor.white
        self.useFlow.pathBackColor = RGBA(255, g: 255, b: 255, a: 0.2)
        
        self.powerView.progress = 0.8
        self.powerView.pathFillColor = UIColor.white
        self.powerView.pathBackColor = RGBA(255, g: 255, b: 255, a: 0.2)
        
    }
}


