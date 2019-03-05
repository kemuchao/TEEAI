//
//  HomeVC.swift

//
//  Created by 柯木超 on 2018/12/5.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit
//import MJRefresh

class TEEHomeVC: ABCBaseVC {
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellWidht:CGFloat = 0
    var cellHeight:CGFloat = 0
    var lineView = UIView()
    var user = TEEUser()
    var deviceData = TEEDeviceData()
    
    enum SegueIdentifier: String {
        case toMifiMain               = "toMifiMainVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(TEEHomeVC.updateData), name: NSNotification.Name(rawValue: kReloadHomeVC), object: nil)

        deviceData.delegate = self
        deviceData.getDevicesList()
        user.delegate = self
        if validString(getUserDefautsData(kUserToken)) == ""{
            presentLoginVC { (data, error) in
                self.user.getUserDetail()
            }
        }else {
            user.getUserDetail()
        }
        
        cellWidht = (kScreenWidth - 96) / 3
        if isIPoneX {
            cellWidht = (kScreenWidth - 96 - 80) / 3
        }
        cellHeight = cellWidht / 108 * 200
        
//        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.deviceData.getDevicesList()
//        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(TEEHomeVC.updateData), name: NSNotification.Name(rawValue: NotifyReloadData), object: nil)
        
        setLayout()
        
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        updateData()
    }
    @objc func updateData() {
        deviceData.getDevicesList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func addDevice(_ sender: Any) {
        
        let mAC = UIAlertController(title: "", message: "添加新设备", preferredStyle: .actionSheet)
        let signInAction1 = UIAlertAction(title: "添加MIFI", style: .default, handler: { action in
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.performSegue(withIdentifier: SegueIdentifier.toMifiMain.rawValue, sender: self)
            
            let urlObj = URL(string:UIApplication.openSettingsURLString)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlObj! as URL, options: [ : ], completionHandler: { Success in
                    
                })} else {
                UIApplication.shared.openURL(urlObj!)
            }
        
            
//            let notificationSettingURL = URL(string: "App-Prefs:root=WIFI")! // 替换该内容即可
//            if UIApplication.shared.canOpenURL(notificationSettingURL) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(notificationSettingURL, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(notificationSettingURL)
//                }
//            }
        })
        let signInAction2 = UIAlertAction(title: "添加其他设备", style: .default, handler: { action in
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { action in
            
        })
        mAC.addAction(signInAction1)
        mAC.addAction(signInAction2)
        mAC.addAction(cancelAction)
        self.present(mAC, animated: true, completion: nil)
    }
 
}

extension TEEHomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TEEHomeCollectionViewCell", for: indexPath) as! TEEHomeCollectionViewCell
        cell.device = deviceData.devices[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidht, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceData.devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.performSegue(withIdentifier: SegueIdentifier.toMifiMain.rawValue, sender: self)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: kScreenWidth, height: 45)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSessionHeaderView", for: indexPath) as! HomeSessionHeaderView
//        return headView
//
//    }
    
    // 这个是两行cell之间的间距（上下行cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 这个是设置uicollectionview的距离的，不是设置uicollectioncell的间距的
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if isIPoneX  {
            return UIEdgeInsets(top: 0, left: 88, bottom: 0, right: 88)

        }else {
            return UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48)
        }
    }
    
    func setLayout() {
        collectionLayout.itemSize = CGSize(width: cellWidht, height: cellHeight)
        collectionLayout.minimumLineSpacing = 20  //上下间隔
        collectionLayout.minimumInteritemSpacing = 20 //左右间隔
        collectionView.setCollectionViewLayout(collectionLayout, animated: true)
    }
}



// MARK: - SSTUIRefreshDelegate
extension TEEHomeVC: SSTUIRefreshDelegate {
    
    func refreshUI(_ data: Any?) {
        ABCProgressHUD.dismiss()
//        self.collectionView.mj_header.endRefreshing()
        if let tmpData = data as? TEEUser {
            self.user = tmpData
        }
        
        if let tmpData = data as? TEEDeviceData {
            self.deviceData = tmpData
            if self.deviceData.devices.count > 0 {
                noDataView.isHidden = true
            }else {
                noDataView.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
}

// MARK: - 跳转
extension TEEHomeVC: SegueHandlerType {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch validString(segue.identifier) {
        case SegueIdentifier.toMifiMain.rawValue:
            
            let _ = segue.destination as! TEETabBarVC
            
            break
       
        default:
            
            break
        }
    }
}
