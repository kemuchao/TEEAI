//
//  MyCenterVC.swift
//  TEEAI
//
//  Created by TEE on 2018/12/20.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit
let kReloadHomeVC = "kReloadHomeVC"
class TEEMyCenterVC: ABCBaseVC {

    enum SegueIdentifier: String {
        case toChangePas               = "toChangePasVC"
        case toSaid               = "toSaidVC"
        case toAboutUs               = "toAboutUs"
        case toTEEChangeMessage               = "toTEEChangeMessageVC"
        
    }
    
    var image = UIImage(named: "boy")
    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        choseImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TEEMyCenterVC.loginSuccess), name: NSNotification.Name(rawValue: NotifyReloadData), object: nil)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(TEEMyCenterVC.loginSuccess), name: NSNotification.Name(rawValue: NotifyReloadData), object: nil)
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotifyReloadData), object: nil)
//    }
    
    @IBAction func logout(_ sender: Any) {
        setUserDefautsData(kUserToken, value: "")
        presentLoginVC { (data, error) in
            // 跳到首页，刷新数据
            self.tabelView.reloadData()
        }
    }
    
    @objc func loginSuccess() {
        self.tabBarController?.selectedIndex = 0;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kReloadHomeVC), object: nil)
    }
}

extension TEEMyCenterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 97
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topcell") as! MyTopCell
            cell.iconImageView.image = self.image
            cell.nameLame.text = biz.user?.nickName
            return cell
        }else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell")
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "yijianCell")
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell")
                return cell!
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "kefuCell")
                return cell!
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "callCell")
                return cell!
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 15))
        view.backgroundColor = RGBA(88, g: 129, b: 192, a: 1)
        return view
    }
    
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.1))
//        view.backgroundColor = UIColor.clear
//        return view
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: SegueIdentifier.toTEEChangeMessage.rawValue, sender: self)
        }else {
            switch indexPath.row {
                case 0:
                self.performSegue(withIdentifier: SegueIdentifier.toChangePas.rawValue, sender: self)
            case 1:
                self.performSegue(withIdentifier: SegueIdentifier.toSaid.rawValue, sender: self)
                
            case 2:
                ABCProgressHUD.showInfoWithStatus(string: "当前已经是最新版本～")
            case 3:
                let mAC = UIAlertController(title: "拨打电话", message: "400-806-1211 ", preferredStyle: .alert)
                let signInAction = UIAlertAction(title: "确认", style: .default, handler: { action in
                    UIApplication.shared.openURL(NSURL(string :"tel://4008061211")! as URL)
                })
                mAC.addAction(signInAction)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { action in
                    
                })
                mAC.addAction(cancelAction)
                self.present(mAC, animated: true, completion: nil)
            case 4:
                
                self.performSegue(withIdentifier: SegueIdentifier.toAboutUs.rawValue, sender: self)
                default:
                    printX("default")
            }
        }
    }
    
}

// MARK:-- 相机操作
extension TEEMyCenterVC {
    
    @objc func choseIcon(){
        self.choseCamera(1)
    }
    
    func choseImage(){
        // 图片设置
        KiClipperHelper.sharedInstance.clipperType = .Move
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        KiClipperHelper.sharedInstance.nav = self.navigationController
        KiClipperHelper.sharedInstance.clippedImgSize = CGSize(width: 200, height: 200)
        
        KiClipperHelper.sharedInstance.clippedImageHandler = {img in
            ABCProgressHUD.show()
            biz.uploadFile(image: img, callback: {(data, error) in
                printX(data)
                printX(error)
                if error != nil {
                    self.image = UIImage(named: "user_icon_default")
                    ABCProgressHUD.showErrorWithStatus(string: "图片上传失败")
                }else {
                    ABCProgressHUD.showSuccessWithStatus(string: "图片上传成功")
                    self.image = img
                    let dict = validDictionary(data)
                    biz.user?.iconPath = validString(dict["msg"])
                }
                self.tabelView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            })
        }
    }
    
    
    func choseCamera(_ maxSelectedCount:Int){
        let iconActionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        iconActionSheet.addAction(UIAlertAction(title:"打开相机拍照", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            openCamera()
        }))
        iconActionSheet.addAction(UIAlertAction(title:"打开相册", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            openPhotoLibrary(maxSelectedCount)
            
        }))
        iconActionSheet.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
        self.present(iconActionSheet, animated: true, completion: nil)
    }
}
