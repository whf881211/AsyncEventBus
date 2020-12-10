//
//  EventBus.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation


class EventMessage:  NSObject, BusMessageRepresentable {
    var replyHandler: EventHandleBlock = {_ in }
    
    var topic: String = ""
    
    var payload: Any?
    
    var replyTopic: String = ""
    
    func reply(payload: Any?) {
        self.bus.publish(topic: replyTopic, payload: payload)
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


class EventNotificationBus: NSObject, BusRepresentable {
    let markedObject: String = "EventBus"
    let messageKey: String = "EventBus.Message"
    var observeArray:  [NSObjectProtocol] = [NSObjectProtocol]()
    
    lazy var topicManager: TopicMaanager = {
        let manager = TopicMaanager.init()
        return manager
    }()
    
    func publish(topic: String) {
        let message = EventMessage.init()
        message.topic = topic
        _publishMessage(message)
    }
    
    func publish(topic: String, payload: Any?) {
        let message = EventMessage.init()
        message.topic = topic
        message.payload = payload
        _publishMessage(message)
    }
    
    func publish(topic: String, payload: Any?, replyHandler: @escaping (BusMessageRepresentable) -> Void) {
        let message = EventMessage.init()
        message.topic = topic
        message.payload = payload
        message.replyHandler = replyHandler
        message.replyTopic = topic + "/$reply"
        self.bus.subscribe(topic: message.replyTopic, handler: replyHandler)
        _publishMessage(message)
    }
    
    lazy var workingQueue: OperationQueue = {
        let queue = OperationQueue.init();
        queue.name = "EventBus.Dispatch.Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
        
    ///订阅
    @discardableResult
    func subscribe(topic: String, handler:@escaping EventHandleBlock) -> SubscribeDisposable {
        ///Register Observer
        weak var observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: topic), object: self.markedObject, queue: self.workingQueue) { [weak self] (notification) in
            ///发送事件
            guard let self = self else {
                return
            }
            if let messageRepresentable = notification.userInfo?[self.messageKey] as? BusMessageRepresentable{
                EventNotificationBus.scheduleDistribute(block: handler, argument: messageRepresentable)
            }
        }
        /// TopicManager
        let _ = self.topicManager.add(topic: topic)
        
        let unsubscribePreBlock = { [weak self] in
            guard let self = self else {
                return
            }
            ///取消监听
            NotificationCenter.default.removeObserver(observer as Any)
            self.topicManager.remove(topic: topic)
        }
        ///返回disposable
        let subscriber = EventBusSubscriber.init(topic, handler: handler, preblock: unsubscribePreBlock)
        return subscriber
    }
    
    func subscribe(replyTopic: String, replyHandler:@escaping EventHandleBlock) {
        ///Register Observer
        weak var observer: NSObjectProtocol?
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: replyTopic), object: self.markedObject, queue: self.workingQueue) { (notification) in
            ///取消监听
            NotificationCenter.default.removeObserver(observer as Any)
            self.topicManager.remove(topic: replyTopic)
            ///发送事件
            if let messageRepresentable = notification.userInfo?[self.messageKey] as? BusMessageRepresentable{
                EventNotificationBus.scheduleDistribute(block: replyHandler, argument: messageRepresentable)
            }
        }
        /// TopicManager
        let _ = self.topicManager.add(topic: replyTopic)
    }
    
    func _publishMessage(_ message: BusMessageRepresentable) {
        if message.topic.hasSuffix("/#") || message.topic.hasSuffix("/+") {
            assert(false, "Topic to publish can not has suffix # or +")
        }
        let topicList = self.topicManager.relateTopics(with: message.topic)
        for topic: String in topicList {
            NotificationCenter.default.post(name: Notification.Name(rawValue: topic), object: self.markedObject, userInfo: [self.messageKey:message])
        }
    }
}

extension EventNotificationBus  {
    private class func scheduleDistribute( block: @escaping EventHandleBlock, argument:BusMessageRepresentable) {
        DispatchQueue.main.async {
            block(argument)
        }
    }
}


