//
//  EventBusProtocol.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation

public typealias EventHandleBlock = (BusMessageRepresentable) -> Void


@objc public protocol SubscribeDisposable {
    var topic: String { get }
    var handler: EventHandleBlock? {get }
    
    @objc(unsubscribe)
    func unsubscribe()
}

@objc public protocol BusRepresentable {
    
    /// Subscribe
    ///
    /// SubscribeDisposable is used to unsubscribe.
    @discardableResult
    @objc(subscribeTopic: action:)
    func subscribe(topic: String, handler:@escaping EventHandleBlock) -> SubscribeDisposable
    
    
    
    ///Publish
    ///
    ///
    @objc(publishTopic:)
    func publish(topic: String)
    
    @objc(publishTopic: payload:)
    func publish(topic: String, payload: Any? )
    
    @objc(publishTopic: payload: replyHandler:)
    func publish(topic: String, payload: Any?, replyHandler: @escaping EventHandleBlock)
    
    
    
    ///Set LogPrinter
    ///
    ///Deliver a LogPrinter to print info
    @objc(setLogPrinter:)
    func setLogPrinter(with printer: LogPrinter)
}



///Message
///
///Subscirber may use reply method to reply the message.
@objc public protocol BusMessageRepresentable {
    var topic: String { get }
    var payload: Any? { get }
    func reply(payload: Any?)
}

///LogPrinter
///
///
@objc public protocol LogPrinter {
    func print(info: String)
}
