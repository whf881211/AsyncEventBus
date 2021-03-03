//
//  EventBusSubscriberProtocol.swift
//  AsyncEventBus
//
//  Created by 王浩沣 on 2021/3/3.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation


@objc public protocol SubscribeDisposable {
    var topic: String { get }
    var handler: EventHandleBlock? {get }
    
    @objc(unsubscribe)
    func unsubscribe()
}
