//
//  EventBus.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation


class EventMessage: NSObject, BusMessage {
    var replyHandler: EventHandleBlock = {_ in }
    
    var topic: String = ""

    var payload: Any?
    
    var replyTopic: String = ""
    
    weak var senderBus: EventBus?
    
    func reply(payload: Any?) {
        senderBus?.publish(topic: replyTopic, payload: payload)
    }
}


class EventBusSubscriber: NSObject, SubscribeDisposable {
    var handler: EventHandleBlock?
    
    internal var topic: String
        
    func unsubscribe() {
        unsubscribePreBlock()
    }
    
    fileprivate var unsubscribePreBlock: () -> ()
    
    
    init( _ topic: String, handler: @escaping EventHandleBlock, preblock: @escaping () -> ()) {
        self.topic = topic
        self.handler = handler
        unsubscribePreBlock = preblock
    }
}

@objc
public class NotificationEventBus: NSObject, EventBus {
    var markObject: String
    var messageKey: String
    var topicHeader: String
    var observeArray:  [NSObjectProtocol] = [NSObjectProtocol]()
    weak var logPrinter: LogPrinter?
    var isForceSync: Bool = false //used for unit test
    
    public required init(with identifier: String) {
        self.markObject = identifier
        self.messageKey = identifier + ".EventBus.Message"
        self.topicHeader = "$" + identifier
        super.init()
    }
    
    public func setLogPrinter(with printer: LogPrinter) {
        logPrinter = printer
    }
    
    lazy var topicManager: TopicManager = {
        let manager = TopicManager.init(with: MqttTopicComparator.init())
        return manager
    }()
    
    public func publish(topic: String) {
        let message = EventMessage.init()
        message.topic = topic
        message.senderBus = self
        publishMessage(message)
    }
    
    public func publish(topic: String, payload: Any?) {
        let message = EventMessage.init()
        message.topic = topic
        message.payload = payload
        message.senderBus = self
        publishMessage(message)
    }
    
    public func publish(topic: String, payload: Any?, replyHandler: @escaping (BusMessage) -> Void) {
        let message = EventMessage.init()
        message.topic = topic
        message.payload = payload
        message.replyHandler = replyHandler
        message.replyTopic = topic + "/$reply"
        message.senderBus = self
        self.subscribe(topic: message.replyTopic, handler: replyHandler)
        publishMessage(message)
    }
    
    lazy var workingQueue: OperationQueue = {
        let queue = OperationQueue.init();
        queue.name = markObject + "EventBus.Dispatch.Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
        
    ///订阅
    @discardableResult
    public func subscribe(topic: String, options: BusOptions, handler: @escaping EventHandleBlock) -> SubscribeDisposable {
        return self.subscribeTopic(topic: topic, handler: handler, options: options)
    }
    
    @discardableResult
    public func subscribe(topic: String, handler:@escaping EventHandleBlock) -> SubscribeDisposable {
        return self.subscribeTopic(topic: topic, handler: handler, options: nil)
    }
    
    
    func subscribeTopic(topic: String, handler: @escaping EventHandleBlock, options: BusOptions?) -> SubscribeDisposable {
        ///Register Observer
        weak var observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: topicHeader + topic), object: markObject, queue: workingQueue) { [weak self] (notification) in
            ///Send Event
            guard let self = self else {
                return
            }
            if let messageRepresentable = notification.userInfo?[self.messageKey] as? BusMessage{
                if (options?.filter?(messageRepresentable) ?? true) {
                    self.distributeEvent(handler: handler, message: messageRepresentable)
                }
            }
        }
        /// TopicManager
        let _ = self.topicManager.add(topic: topic)
        
        let unsubscribePreBlock = { [weak self] in
            guard let self = self else {
                return
            }
            ///remove Observer
            NotificationCenter.default.removeObserver(observer as Any)
            self.topicManager.remove(topic: topic)
        }
        ///return disposable
        let subscriber = EventBusSubscriber.init(topic, handler: handler, preblock: unsubscribePreBlock)
        return subscriber
    }

    
    func publishMessage(_ message: BusMessage) {
        if !message.topic.hasPrefix("/") {
            assert(false, "Topic must start with /")
        }
        if message.topic.hasSuffix("/#") || message.topic.hasSuffix("/+") {
            assert(false, "Topic to publish can not has suffix # or +")
        }
        logPrinter?.print(info: "【EventBus】publish message topic: " + message.topic + " payload: " + message.payload.debugDescription)
        let topicList = self.topicManager.relateTopics(with: message.topic)
        for topic: String in topicList {
            NotificationCenter.default.post(name: Notification.Name(rawValue: topicHeader + topic), object: markObject, userInfo: [messageKey: message])
        }
    }
    func distributeEvent(handler: @escaping EventHandleBlock, message: BusMessage ) {
        if isForceSync {
            NotificationEventBus.syncDistribute(block: handler, argument: message)
        } else {
            NotificationEventBus.asyncDistribute(block: handler, argument: message)
        }
    }
    
}

extension NotificationEventBus  {
    private class func asyncDistribute( block: @escaping EventHandleBlock, argument: BusMessage) {
        DispatchQueue.main.async {
            block(argument)
        }
    }
}

// use in UnitTest
extension NotificationEventBus  {
    public func forceSync(_ sync: Bool) {
        isForceSync = sync
    }
    private class func syncDistribute( block: @escaping EventHandleBlock, argument: BusMessage) {
        block(argument)
    }
}

