//
//  AppDelegate.swift

//
//  Created by 柯木超 on 2018/12/5.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper


let kUMAppid              = "5be28aa9b465f52fe50002b5"

let wxappid               = "wx2a6b437992332c95"
let wxappSecret           = "85b8e40e28110d88ba00a0bc2efd2224"

let qqappid               = "1107862362"
let qqappSecret           = "KRvtBFARumKcN9cG"
// 设备唯一ID
var deviceId = ""

var appDelegate           : AppDelegate!
let biz                   = BizRequestCenter()
let dateFormatter         = DateFormatter()

weak var gMainTC          : UITabBarController?
let timeFormatter         = DateFormatter()


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hostReachability:Reachability!
    var routerReachability:Reachability!
    var mgr:AFHTTPRequestOperationManager! {
        get{
            let mgrt = AFHTTPRequestOperationManager()
            mgrt.requestSerializer.timeoutInterval = 30
            mgrt.requestSerializer.setValue("-1", forHTTPHeaderField: "Expires")
            mgrt.requestSerializer.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            mgrt.requestSerializer.setValue("zh-CN", forHTTPHeaderField: "Accept-Language")
            mgrt.requestSerializer.setValue("platform=mifi", forHTTPHeaderField: "Cookie")
            let perfer = "http://\(validString(NIWifiTool.getRouterIp()))/index.html"
            mgrt.requestSerializer.setValue(perfer, forHTTPHeaderField: "Referer")
            mgrt.requestSerializer.setValue(validString(NIWifiTool.getRouterIp()), forHTTPHeaderField: "Host")
            mgrt.requestSerializer.setValue("no-cache", forHTTPHeaderField: "Pragma")
            mgrt.responseSerializer = AFHTTPResponseSerializer()
            return mgrt
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        SVProgressHUD.setImageViewSize(CGSize(width: 70, height: 70))
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black)
        SVProgressHUD.setDefaultStyle(.light)
        
        NIUerInfoAndCommonSave.saveValue(NetValueLost, key: ConnectMIFI)
        let ip = NIWifiTool.getRouterIp()
        NIUerInfoAndCommonSave.saveValue(ip, key: ROUTEIP)
        self.dealReachablity()
        return true
    }

   

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appOut"), object: nil)
        var appRootVC = getTopWindow()?.rootViewController
        if appRootVC?.presentedViewController != nil {
            appRootVC = appRootVC?.presentedViewController
        }
        if appRootVC != nil {
            if appRootVC!.isKind(of: ShowWIFIViewController.classForCoder()) {
                appRootVC?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appIn"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dealReachablityNotification"), object: nil)
//        dealReachablity()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dealReachablityNotification"), object: nil)
        dealReachablity()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func dealReachablity() {

        NotificationCenter.default.addObserver(self, selector: #selector(appReachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        // 检测指定服务器是否可达
        let ip = NIWifiTool.getRouterIp()
        let url = "http://\(validString(ip))/xml_action.cgi?method=get&module=duster&file=locale"
        hostReachability = Reachability(hostName: url)
        
        hostReachability.startNotifier()

        // 检测默认路由是否可达
        routerReachability = Reachability.forInternetConnection()
        routerReachability.startNotifier()
    }
    
    /// 当网络状态发生变化时调用
    @objc func appReachabilityChanged(_ notification: Notification) {
        let reachT = notification.object
        if reachT is Reachability {
            let reach = reachT as! Reachability
            let status = reach.currentReachabilityStatus()
            // 两种检测:路由与服务器是否可达  三种状态:手机流量联网、WiFi联网、没有联网
            if reach == self.routerReachability {
                if status == NotReachable {
                    NIUerInfoAndCommonSave.saveValue(NetValueLost, key: ConnectMIFI)
                    //                    biz.wifiDict = [NetKeyChangeNet:NetValueLost]
                    setUserDefautsData(NetKeyChangeNet, value: NetValueLost)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyNetChangeName), object: nil, userInfo: [NetKeyChangeNet:NetValueLost])
                    
                }else if status == ReachableViaWiFi {
                    printX("routerReachability ReachableViaWiFi")
                }else if status == ReachableViaWWAN {
                    NIUerInfoAndCommonSave.saveValue(NetValueCommonNet, key: ConnectMIFI)
                    
                    setUserDefautsData(NetKeyChangeNet, value: NetValueCommonNet)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyNetChangeName), object: nil, userInfo: [NetKeyChangeNet:NetValueCommonNet])
                }
            }
            if reach == self.hostReachability {
                
                reCheckNetConnect()
                reCheckCPE()
            }
        }
    }
    
    func reCheckNetConnect (){
        let ip = NIWifiTool.getRouterIp()
        let url = "http://\(validString(ip))/xml_action.cgi?method=get&module=duster&file=locale"
        
        
        mgr.get(url, parameters: nil, success: { (operation, responseObject) in
            let language = LanguageModel.initWithResponseXmlString(operation?.responseString)
            if (validString(language?.errorCause)) != "" {
                return
            }
            NIUerInfoAndCommonSave.saveValue(Version1802, key: VersionName)
            if validString(NIUerInfoAndCommonSave.getValueFromKey(ConnectMIFI)) == NetValueMIFINet {
                return
            }
            NIUerInfoAndCommonSave.saveValue(NetValueMIFINet, key: ConnectMIFI)
            let dictZ:[String:Any] = [NetKeyChangeNet:NetValueMIFINet]
            
             //  连接miwi重新打开网络，正常会进入这里
            setUserDefautsData(NetKeyChangeNet, value: NetValueMIFINet)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyNetChangeName), object: dictZ)
        }) { (operation, error) in
//            NIUerInfoAndCommonSave.saveValue(Version1802, key: VersionName)
//            if validString(NIUerInfoAndCommonSave.getValueFromKey(ConnectMIFI)) == NetValueMIFINet {
//                return
//            }
            NIUerInfoAndCommonSave.saveValue(NetValueLost, key: ConnectMIFI)
           
            let dictZ:[String:Any] = [NetKeyChangeNet:NetValueLost]
            
            setUserDefautsData(NetKeyChangeNet, value: NetValueLost)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyNetChangeName), object: dictZ)
        }

    }


    func reCheckCPE () {
        let ip = NIWifiTool.getRouterIp()
        let url = "http://\(validString(ip))/xml_action.cgi?method=set"
        let muStr = NSMutableString(string: "<?xml version=\"1.0\" encoding=\"US-ASCII\"?>")
        muStr.append("<RGW><param>")
        muStr.appendFormat("<method>call</method><session>000</session><obj_path>router</obj_path><obj_method>get_language_choice</obj_method>")
        muStr.appendFormat("</param></RGW>")
        mgr.post(url, parameters: nil, constructingBodyWith: { (formData) in
            let customEnc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))

            formData?.appendPart(withFileData: muStr.data(using: customEnc), name: "data", fileName: "null", mimeType: "application/octet-stream")

        }, success: { (operation, responseObject) in
            let language = LanguageModel.initWithResponseXmlString(operation?.responseString)
            if (validString(language?.errorCause)) == "" && (validString(language?.language) as NSString).length == 0 {
                return
            }
            NIUerInfoAndCommonSave.saveValue(VersionCPE, key: VersionName)
            if validString(NIUerInfoAndCommonSave.getValueFromKey(ConnectMIFI)) == NetValueMIFINet {
                self.reCheckNetConnect()
                return
            }
            NIUerInfoAndCommonSave.saveValue(NetValueMIFINet, key: ConnectMIFI)
            let dictZ:[String:Any] = [NetKeyChangeNet:NetValueMIFINet]
            setUserDefautsData(NetKeyChangeNet, value: NetValueMIFINet)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "netChange"), object: dictZ)
            
        }) { (data, rror) in
            if validString(NIUerInfoAndCommonSave.getValueFromKey(VersionName)) == Version1802 {
                return
            }else {
                NIUerInfoAndCommonSave.saveValue(NetValueLost, key: ConnectMIFI)
                let dictZ:[String:Any] = [NetKeyChangeNet:NetValueLost]
                setUserDefautsData(NetKeyChangeNet, value: NetValueLost)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyNetChangeName), object: dictZ)
            }
        }
    }
}

