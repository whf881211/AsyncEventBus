//
//  TopicManager.swift
//  EventBusExample
//
//  Created by 王浩沣 on 2020/11/21.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation
class TopicMaanager: NSObject {
    
    override init() {
        topicDict = [String: Int]()
        super.init()
    }
    
    private var topicDict: [String: Int]

    /// /a/b对应情况有：
    /// /a/b
    /// /a/+
    /// /a/+/b/c
    /// /a/#
    /// /a/b/#
    private func compareTopicIsRelate(with Topic: String, compareTo TopicInList: String) -> Bool{
        if Topic == TopicInList {
            return true
        }
        let topicSplitArray = Topic.split(separator: Character.init("/"))
        let topicPartCount = topicSplitArray.count
        if (topicSplitArray.last == "$reply") {
            ///是回复topic
            return false
        }
        
        let topicInListSplitArray = TopicInList.split(separator: Character.init("/"))
        let topicInListPartCount = topicInListSplitArray.count
        let topicInListCorrespondSubString = topicInListSplitArray[(topicSplitArray.count - 1)]

        ///先检查前面部分
        for i in 0 ..< (topicSplitArray.count - 1) {
            if topicInListSplitArray[i] != topicSplitArray[i] {
                return false
            }
        }
        ///检查是否满足 /a/+或/a/+/b/c
        if topicInListCorrespondSubString == "+" {
            return true
        }
        ///检查是否满足 /a/#
        if topicPartCount == topicInListPartCount && topicInListCorrespondSubString == "#" {
            return true
        }
        ///检查是否满足 /a/b/#
        if (topicPartCount + 1) == topicInListPartCount && topicInListCorrespondSubString == topicSplitArray.last && topicInListSplitArray[(topicSplitArray.count)] == "#" {
            return true
        }
        return false
      
    }
    
    func relateTopics(with Topic: String) -> Set<String> {
        var resSet: Set<String> = Set<String>()
  
        let topicList = self.topicDict.keys
        
        for topicInList: String in topicList {
            if self.compareTopicIsRelate(with: Topic, compareTo: topicInList) {
                resSet.insert(topicInList)
            }
        }
        return resSet;
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
