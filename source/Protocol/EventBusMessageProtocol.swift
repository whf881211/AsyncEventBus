//
//  EventBusMessageProtocol.swift
//  AsyncEventBus
//
//  Created by 王浩沣 on 2021/3/3.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation

///Message
///
///Subscirber may use reply method to reply the message.
@objc public protocol BusMessage {
    var topic: String { get }
    var payload: Any? { get }
    func reply(payload: Any?)
}
