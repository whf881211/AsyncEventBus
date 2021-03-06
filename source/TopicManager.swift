//
//  TopicManager.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/11/21.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation
class TopicManager: NSObject {
    
    private var topicComparator: TopicComparatorProtocol
    
    init(with comparaotr: TopicComparatorProtocol) {
        topicComparator = comparaotr
        topicDict = [String: Int]()
        super.init()
    }
    
    private var topicDict: [String: Int]

    
    func relateTopics(with Topic: String) -> Set<String> {
        var resSet: Set<String> = Set<String>()
  
        let topicList = self.topicDict.keys
        
        for topicInList: String in topicList {
            if isMatchedTopicForReply(Topic, isRelateTo: topicInList) {
                resSet.insert(topicInList)
            } else if topicComparator.topic(Topic, isRelateTo: topicInList) {
                resSet.insert(topicInList)
            }
        }
        return resSet;
    }
    
    func isMatchedTopicForReply(_ replyTopic: String, isRelateTo publishedTopic: String) -> Bool {
        let topicSplitArray = replyTopic.split(separator: Character.init("/"))
        if topicSplitArray.last == "$reply" {
            ///if is replyTopic, find the same one
            if replyTopic == publishedTopic {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    
    func preCheck(topic Topic: String) -> Bool {
        if Topic.count == 0 {
            return false
        }
        return true
    }
    
    
    func add(topic Topic: String) -> Bool {
        if !preCheck(topic: Topic) {
            return false
        }
        let count = topicDict[Topic]
        var newCount: Int
        if let count = count {
            newCount = count + 1
        } else{
            newCount = 1
        }
        topicDict[Topic] = newCount
        return true
    }
    
    func remove(topic Topic: String) {
        let count = topicDict[Topic]
        var newCount: Int = 0
        if let count = count {
            assert(count != 0, "WRONG TOPIC COUNT")
            newCount = count - 1
        } else{
            assert(false, "WRONG TOPIC COUNT")
        }
        topicDict[Topic] = newCount
    }
    
}
