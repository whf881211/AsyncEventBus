//
//  BusProvider.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/16.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation
@_exported import AsyncEventBus

@objcMembers
class BusProvider: NSObject {
    static let instance: EventBus = {
        let instance = NotificationEventBus(with: "main")
        return instance
    }()
}

extension NSObject {
    @objc var bus: EventBus {
        return BusProvider.instance
    }
}
