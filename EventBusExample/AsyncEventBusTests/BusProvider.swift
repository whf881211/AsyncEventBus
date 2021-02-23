//
//  BusProvider.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/16.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation
@testable import AsyncEventBus

@objcMembers
class BusProvider: NSObject {
     static let instance: BusRepresentable = {
        let instance = EventNotificationBus(with: "main")
        return instance
      }()
}

extension NSObject {
    @objc var bus: BusRepresentable {
        return BusProvider.instance
    }
}
