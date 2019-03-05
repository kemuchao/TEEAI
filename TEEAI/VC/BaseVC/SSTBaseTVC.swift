//
//  SSTBaseTableViewController.swift
//  sst-mobile
//
//  Created by Amy on 16/4/12.
//  Copyright © 2016年 lzhang. All rights reserved.
//

import UIKit

class SSTBaseTVC: UITableViewController {
    
    var backButton: UIButton?

    // 收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white.withAlphaComponent(0.7)
    }

    
    func fetchData() {}
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        backButton?.removeFromSuperview()
        
    }
    
    func addLeftItemButton() -> Void {
        
        backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton?.frame = kBackButtonRect
        backButton?.addTarget(self, action: #selector(clickedBackBarButton), for: UIControl.Event.touchUpInside)
        
        backButton?.setImage(UIImage(named:kIconBackImgName), for: UIControl.State())
        backButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 10)
        
        if let tmpButton = backButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tmpButton)
        }
    }
    
    @objc func clickedBackBarButton() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

