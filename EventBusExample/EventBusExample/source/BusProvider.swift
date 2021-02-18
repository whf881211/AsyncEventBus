//
//  BusProvider.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/16.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
class BusProvider: NSObject {
     static let instance: BusRepresentable = {
        let instance = EventNotificationBus()
        return instance
      }()
    
    static let clientId: String = {
        let str = UIDevice.current.identifierForVendor?.uuidString
        return str ?? ""
    }()
    
}

extension NSObject {
    @objc var bus: BusRepresentable {
        return BusProvider.instance
    }
}
