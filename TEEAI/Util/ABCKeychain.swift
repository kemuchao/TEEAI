//
//  ABCKeylet saveSuccessful: Bool = KeychainWrapper.standard.swift
//  ABCTime
//
//  Created by 林丽萍 on 2018/8/13.
//  Copyright © 2018年 Macoro. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class ABCKeychain: NSObject {
    
    static func setDeviceId(value:String) {
        #if DEV
        let saveSuccessful: Bool = KeychainWrapper.standard.set(value, forKey: "UUIDDEV")
        #elseif QA
        let saveSuccessful: Bool = KeychainWrapper.standard.set(value, forKey: "UUIDQA")
        #elseif SIM
        let saveSuccessful: Bool = KeychainWrapper.standard.set(value, forKey: "UUIDSIM")
        #else
        let saveSuccessful: Bool = KeychainWrapper.standard.set(value, forKey: "UUID")
        #endif
        
        printX("插入数据==== \(saveSuccessful)")
    }
    
    static func getDeviceId()-> String {
        
        #if DEV
         let retrievedString: String? = KeychainWrapper.standard.string(forKey: "UUIDDEV")
        return validString(retrievedString)
        #elseif QA
         let retrievedString: String? = KeychainWrapper.standard.string(forKey: "UUIDQA")
        return validString(retrievedString)
        #elseif SIM
         let retrievedString: String? = KeychainWrapper.standard.string(forKey: "UUIDSIM")
        return validString(retrievedString)
        #else
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "UUID")
        return validString(retrievedString)
        #endif
        
        
    }
    
  
}
