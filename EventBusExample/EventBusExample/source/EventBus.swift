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
    
    func reply(payload: Any?) {
    }
    
}


class EventBusSubscriber: NSObject, SubscribeDisposable {
    var handler: EventHandleBlock?
    
    internal var topic: String
        
    func unsubscribe() {
        ///TODO
    }
    
    fileprivate var unsubscribePreBlock: () -> ()
    
    
    init( _ topic: String, handler: @escaping EventHandleBlock, preblock: @escaping () -> ()) {
        self.topic = topic
        self.handler = handler
        unsubscribePreBlock = preblock
    }
}




class EventNotificationBus: NSObject, BusRepresentable {
    let markedObject: String = "EventBus.Dispatch"
    let messageKey: String = "EventBus.Message"
    
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
        _publishMessage(message)
    }
    
    
    lazy var workingQueue: OperationQueue = {
        let q = OperationQueue.init();
        q.name = "EventBus.Dispatch.Queue"
        q.maxConcurrentOperationCount = 1
        return q
    }()
        
    ///订阅
    func subscribe(topic: String, handler:@escaping EventHandleBlock) -> SubscribeDisposable {
        ///Register Observer
        weak var observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: topic), object: self.markedObject, queue: self.workingQueue) { (notification) in
            ///发送事件
            if let messageRepresentable = notification.userInfo?[self.messageKey] as? BusMessageRepresentable{
                EventNotificationBus.scheduleDistribute(block: handler, argument: messageRepresentable)
            }
        }
        ///TODO TopicManager
        let unsubscribePreBlock = {
            NotificationCenter.default.removeObserver(observer as Any)
        }
        ///返回disposable
        let subscriber = EventBusSubscriber.init(topic, handler: handler, preblock: unsubscribePreBlock)
        return subscriber
    }
    
    func _publishMessage(_ message: BusMessageRepresentable) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: message.topic), object: markedObject, userInfo: [self.messageKey:message])
    }
}

extension EventNotificationBus  {
    private class func scheduleDistribute(block: EventHandleBlock, argument:BusMessageRepresentable) {
        block(argument)
    }
}


