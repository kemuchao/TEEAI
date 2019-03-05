//
//  TEECommitMessageVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/7.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEECommitMessageVC: ABCBaseVC {

    @IBOutlet weak var tableView: UITableView!
    var user = TEEUser()
//    var phone = ""
//    var iconPath = ""
//    var birthday = ""
//    var nickName = ""
//    var height = ""
//    var wight = ""
//    var sex = ""
//    var address = ""
    var image = UIImage(named: "user_icon_default")
    var heights = ["140","145","150","155","160","165","170","175","180","185","190","195"]
    var weight = ["80","85","90","95","100","105","110","115","120","125","130","135","140","145","150","155","160","165"]
    
    enum SegueIdentifier: String {
        case toAddress           = "toAddressVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choseImage()
        
        let nav = self.navigationController as! TEEBaseNC
        nav.backButton.setImage(UIImage(), for: UIControl.State.normal)
        nav.backButton.setTitle("保存", for: UIControl.State.normal)
        nav.backButton.removeTarget(self.navigationController, action: #selector(nav.didBackButton(sender:)), for: UIControl.Event.touchUpInside)
        nav.backButton.addTarget(self, action:#selector(didSaveButton(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func didSaveButton(sender:UIButton){
        user.token = validString(getUserDefautsData(kUserToken))
        user.updateUser(user: user) { (data, error) in
            if error == nil {
                ABCProgressHUD.showSuccessWithStatus(string: "注册成功")
                TaskUtil.delayExecuting(1, block: {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyReloadData), object: nil, userInfo: nil)
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            }
        }
        
    }
    
    @IBAction func goto(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension TEECommitMessageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 6
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell")
            let imageView = cell?.viewWithTag(1001) as! UIImageView
            imageView.image = self.image
            return cell!
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nickNameCell")
                let nickNameTextField = cell?.viewWithTag(1003) as! UITextField
                nickNameTextField.text = user.nickName
                return cell!
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell")
                let phoneLabel = cell?.viewWithTag(1004) as! UILabel
                phoneLabel.text = user.phone
                return cell!
            }
            if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCell")
                let birthdayLabel = cell?.viewWithTag(1002) as! UILabel
                birthdayLabel.text = user.birth
                return cell!
            }
            if indexPath.row == 3 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sexCell")
                let sexLabel = cell?.viewWithTag(1007) as! UILabel
                if validInt(user.sex) == 1 {
                    sexLabel.text = "男"
                }
                if validInt(user.sex) == 2 {
                    sexLabel.text = "女"
                }
                return cell!
            }
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "hightCell")
                let heightLabel = cell?.viewWithTag(1006) as! UILabel
                heightLabel.text = validString(user.height)
                return cell!
            }
            if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "weightCell")
                let wightLabel = cell?.viewWithTag(1005) as! UILabel
                wightLabel.text = validString(user.weight)
                return cell!
            }else {
                return UITableViewCell()
            }
        }
        if indexPath.section == 2{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell")
                let addressLabel = cell?.viewWithTag(1008) as! UILabel
                addressLabel.text = validString(user.address)
                return cell!
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell")
                return cell!
            }else {
                return UITableViewCell()
            }
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            choseIcon()
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            let pView = loadNib("TEEDatePickerView") as! TEEDatePickerView
            pView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            pView.picketViewClick = { date in
                printX(date)
                self.user.birth = date
                self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
            self.view.addSubview(pView)
            //            UIApplication.shared.windows.first?.addSubview(pView)
        }
        if indexPath.section == 1 && indexPath.row == 3 {
            let mAC = UIAlertController(title: "", message: "选择性别", preferredStyle: .actionSheet)
            
            let signInAction1 = UIAlertAction(title: "男", style: .default, handler: {[weak self] action in
                self?.user.sex = 1
                self?.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            })
            mAC.addAction(signInAction1)
            
            let signInAction2 = UIAlertAction(title: "女", style: .default, handler: {[weak self] action in
                self?.user.sex  = 2
                self?.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            })
            mAC.addAction(signInAction2)
            let signInAction3 = UIAlertAction(title: "取消", style: .cancel, handler: { action in
            })
            mAC.addAction(signInAction3)
            self.present(mAC, animated: true, completion: nil)
        }
        
        if indexPath.section == 1 && indexPath.row == 4 {
            let pView = loadNib("TEEPicketView") as! TEEPicketView
            pView.frame =  CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            pView.data = heights
            pView.titleLabel.text = "请选择身高"
            pView.picketViewClick = { date in
                printX(date)
                self.user.height = validInt(date)
                self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
            self.view.addSubview(pView)
        }
        
        if indexPath.section == 1 && indexPath.row == 5 {
            let pView = loadNib("TEEPicketView") as! TEEPicketView
            pView.frame =  CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            pView.data = weight
            pView.titleLabel.text = "请选择体重"
            pView.picketViewClick = { date in
                printX(date)
                self.user.weight = validInt(date)
                self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
            self.view.addSubview(pView)
            //            UIApplication.shared.windows.first?.addSubview(pView)
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            self.performSegue(withIdentifier: SegueIdentifier.toAddress.rawValue, sender: self)
        }
    }
}
// MARK:-- 相机操作
extension TEECommitMessageVC {
    
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
                    self.user.iconPath = validString(dict["msg"])
                }
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
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

// MARK: - 跳转
extension TEECommitMessageVC: SegueHandlerType {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch validString(segue.identifier) {
        case SegueIdentifier.toAddress.rawValue:
            let destVC = segue.destination as! TEEAddressVC
            destVC.saveClick = {[weak self] addressStr in
                self?.user.address = addressStr
                self?.tableView.reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
            }
            break
        default:
            break
        }
    }
}
