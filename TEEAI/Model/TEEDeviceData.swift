//
//  TEEDeviceData.swift
//  TEEAI
//
//  Created by TEE on 2018/12/18.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEEDeviceData: BaseModel {
    var devices = [TEEDevice]()
    
    func update(dict: Dictionary<String, Any>) {
        devices.removeAll()
        for dict in validArray(dict["data"]) {
            if let transaction = TEEDevice(JSON:validDictionary(dict)) {
                if validString(transaction.ip) != "" {
                    devices.append(transaction)
                }
            }
        }
        if biz.homeNowDevice != nil {
            devices.append(biz.homeNowDevice!)
        }
        setUserDefautsData("devices", value: validArray(dict["data"]))
    }
    
    func getDevicesList(){
        
        biz.getDeviceList() { (data, error) in
            self.update(dict: validDictionary(data))
            
            self.delegate?.refreshUI(self)
        }
    }
}
