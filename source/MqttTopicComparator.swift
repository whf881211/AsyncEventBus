//
//  TopicMatcher-MqttImp.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2021/2/18.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation


/// /a/b对应情况有：
/// /a/b
/// /a/+
/// /a/+/b/c 暂不支持
/// /a/#
/// /a/b/#

/// /a/b/c 对应 /a/#还不支持
class MqttTopicComparator: NSObject, TopicComparatorProtocol {
    func topic(_ topic: String, isRelateTo subscribedTopic: String) -> Bool {
        if topic == subscribedTopic {
            return true
        }
        let subscribedTopicSplitArray = subscribedTopic.split(separator: Character.init("/"))
        if subscribedTopicSplitArray.last == "#" {
            return self.topic(topic, compareToPoundTopic: subscribedTopic)
        }
        return self.topic(topic, compareToPlusTopic: subscribedTopic)
    }
    
    //Match #
    func topic(_ topic: String, compareToPoundTopic subscribedTopic: String) -> Bool {
        let topicSplitArray = topic.split(separator: Character.init("/"))
        
        let subscribedTopicSplitArray = subscribedTopic.split(separator: Character.init("/"))
        let subscribedTopicPartCount = subscribedTopicSplitArray.count
        let contentPartCount = subscribedTopicPartCount - 1
        
        if contentPartCount == 0 {
            return true
        }
        
        ///逐各部分检查
        for i in 0 ..< (contentPartCount - 1) {
            if subscribedTopicSplitArray[i] != topicSplitArray[i] {
                return false
            }
        }
        return true
    }
    
    //Match +
    func topic(_ topic: String, compareToPlusTopic subscribedTopic: String) -> Bool {
        let topicSplitArray = topic.split(separator: Character.init("/"))
        
        let subscribedTopicSplitArray = subscribedTopic.split(separator: Character.init("/"))
        let subscribedTopicPartCount = subscribedTopicSplitArray.count
                
        if topicSplitArray.count != subscribedTopicPartCount {
            return false
        }
        
        ///逐各部分检查
        for i in 0 ... (topicSplitArray.count - 1) {
            if subscribedTopicSplitArray[i] != topicSplitArray[i] && subscribedTopicSplitArray[i] != "+" {
                return false
            }
        }
        return true
    }
    
    
}
