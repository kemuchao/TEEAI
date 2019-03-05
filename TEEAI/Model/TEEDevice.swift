//
//  TEEDevice.swift
//  TEEAI
//
//  Created by TEE on 2018/12/18.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit
import ObjectMapper
let kdeviceId       = "deviceId" //设备ID
let kdeviceType     = "deviceType" //设备类型 0:路由器,1:mifi
let kdeviceMac      = "deviceMac" //设备MAC地址
let kdeviceIp       = "deviceIp" //设备IP地址
let kdeviceName     = "deviceName"
let kdeviceIcon     = "deviceIcon"



class TEEDevice: BaseModel {
    
    var id: Int!
    var type: String?
    var macAddress :String?
    var ip :String?
    var name :String?
    var icon :String?
    
    @objc
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id           <- map[kdeviceId]
        type         <- map[kdeviceType]
        macAddress   <- map[kdeviceMac]
        ip           <- map[kdeviceIp]
        name         <- map[kdeviceName]
        icon         <- map[kdeviceIcon]
    }
}

