//
//  EventBus.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation


class EventMessage:  NSObject, BusMessageRepresentable {

    var topic: String = ""
    
    var payload: Any = ()
    
    func reply(payload: Any?) {
        
    }
}

typealias eventBlock = () -> ()

class EventBusSubscriber: NSObject, SubscriberRepresentable {
    func unsubscribe() {
        
    }
    
    func topic() -> String {
        return self.innerTopic
    }
    
    func handler() -> ((Any?) -> ())? {
        return self.innerHandler
    }
    
    private var innerTopic: String
    private var innerHandler: (Any?) -> ()
    
    
    init(Topic topic: String, _ handler: @escaping (Any?) -> ()  ) {
        innerTopic = topic
        innerHandler = handler
    }
    
    
}


class EventNotificationBus: NSObject {
    
    lazy var queue: OperationQueue = {
        let q = OperationQueue.init();
        q.name = "EventBus.Dispatch.Queue"
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private class func scheduleDistribute() {
        
    }
    
    func subscribe(topic: String, action: @escaping (_ payload: Any?)->()) -> SubscriberRepresentable {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: topic), object: nil, queue: self.queue) { (notification) in
            
            ///发送事件
            EventNotificationBus.scheduleDistribute();
            
            }
        let subscriber = EventBusSubscriber.init(Topic: topic, action)
        return subscriber
    }
    

    
    
}


