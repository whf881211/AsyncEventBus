//
//  TopicParser.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2021/2/7.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation

protocol TopicComparatorProtocol: NSObject {
    func topic(_ topic: String, isRelateTo subscribedTopic: String) -> Bool;
}
