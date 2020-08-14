//
//  EventBusProtocol.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation


@objc protocol SubscriberRepresentable  {
    
    func unsubscribe();
    
    func topic() -> String
    
    func handler() -> ((_ payload: Any? )->())?
}


@objc protocol BusRepresentable {
    
    func subscribe(topic: String, action: (_ payload: Any?)->()) -> SubscriberRepresentable
    
    func publish(topic: String, payload: Any? )
    
    func publish_once(topic: String, payload: Any? )
}


@objc protocol BusMessageRepresentable {
    
    var topic: String { get set }
    
    var payload: Any { get set }

    func reply(payload: Any?)
}
