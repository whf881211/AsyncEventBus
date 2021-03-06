//
//  EventBusProtocol.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//





import Foundation

public typealias EventHandleBlock = (BusMessage) -> Void

@objc public protocol EventBus {
    
    /// Subscribe
    ///
    /// SubscribeDisposable is used to unsubscribe.
    @discardableResult
    @objc(subscribeTopic: handler:)
    func subscribe(topic: String, handler: @escaping EventHandleBlock) -> SubscribeDisposable
    
    @discardableResult
    @objc(subscribeTopic: handler: filter:)
    func subscribe(topic: String, options: BusOptions, handler: @escaping EventHandleBlock) -> SubscribeDisposable

    
    
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
