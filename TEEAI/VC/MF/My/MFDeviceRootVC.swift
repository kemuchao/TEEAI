//
//  TEEDeviceRootVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/9.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class MFSetRootVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    enum SegueIdentifier: String {
        
        case toPackageViewController                   = "toPackageViewController"
        case toWiFiSettingViewController               = "toWiFiSettingViewController"
        case toMobileNetSettingViewController          = "toMobileNetSettingViewController"
        case toConnectDevicesViewController            = "toConnectDevicesViewController"
        case toManagerPSWSettingViewController         = "toManagerPSWSettingViewController"
        case toRouterManagerViewController             = "toRouterManagerViewController"
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.creanLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ABCProgressHUD.dismiss()
    }
}

extension MFSetRootVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 4
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        view.backgroundColor = RGBA(88, g: 129, b: 192, a: 1)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "powerCell")
            return cell!
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell")
                return cell!
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell")
                return cell!
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell")
                return cell!
            }
            else  if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell")
                return cell!
            }else {
                return UITableViewCell()
            }
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "luyouCell")
            return cell!
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath .section == 0) {
            self.performSegue(withIdentifier: SegueIdentifier.toPackageViewController.rawValue, sender: self)
        }else if (indexPath .section == 1)  {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: SegueIdentifier.toWiFiSettingViewController.rawValue, sender: self)
            case 1:
                self.performSegue(withIdentifier: SegueIdentifier.toMobileNetSettingViewController.rawValue, sender: self)
            case 2:
                self.performSegue(withIdentifier: SegueIdentifier.toConnectDevicesViewController.rawValue, sender: self)
            case 3:
                self.performSegue(withIdentifier: SegueIdentifier.toManagerPSWSettingViewController.rawValue, sender: self)
           
            default:
                break
            }
        }else {
            self.performSegue(withIdentifier: SegueIdentifier.toRouterManagerViewController.rawValue, sender: self)
        }
    }
}
