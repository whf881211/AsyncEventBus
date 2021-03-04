//
//  AsyncEventBusTests.swift
//  AsyncEventBusTests
//
//  Created by ryanhfwang on 2021/2/20.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import XCTest
@testable import AsyncEventBus

class AsyncEventBusTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEventBusReply() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"
        let expect: XCTestExpectation = XCTestExpectation.init()

        self.bus.subscribe(topic: subscribeTopic) { (message) in
            message.reply(payload: nil)
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    func testEventBusNotReply() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    func testEventBusReplyDifferentTopic() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopicA"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
            message.reply(payload: nil)
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    
    func testEventBusReplySepcTopic() throws {
        
        let subscribeTopic: String = "/testTopic/#"
        let publishTopic: String = "/testTopic/a"
        let publishTopicShouldReply: String = "/testTopic/b"

        let expectNotCall: XCTestExpectation = XCTestExpectation.init()
        expectNotCall.isInverted = true
        let expectCall: XCTestExpectation = XCTestExpectation.init()
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
            if message.topic == publishTopicShouldReply {
                message.reply(payload: nil)
            }
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expectNotCall.fulfill()
        }
        
        self.bus.publish(topic: publishTopicShouldReply, payload: nil) { (message) in
            expectCall.fulfill()
        }
        self.wait(for: [expectCall, expectNotCall], timeout: 1)
    }
    
    func testMultiBus() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        let seExpect: XCTestExpectation = XCTestExpectation.init()
        
        let bus = NotificationEventBus.init(with: "secondary")
        bus.subscribe(topic: subscribeTopic) { (message) in
            seExpect.fulfill()
        }
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
            expect.fulfill()
        }
        
        bus.publish(topic: publishTopic)

        self.wait(for: [expect], timeout: 1)
    }
    
    
    func testEventBusFilter() throws {
        
        let subscribeTopic: String = "/testTopic/+"
        let publishTopic: String = "/testTopic/abc"
        let expect: XCTestExpectation = XCTestExpectation.init()
        
        
        let options: BusOptions = BusOptions.init { (message) -> Bool in
            return message.topic.hasSuffix("abc")
        }
    
        self.bus.subscribe(topic: subscribeTopic, options: options) { (message) in
            expect.fulfill()
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    
    func testEventBusFilterNotInvoke() throws {
        
        let subscribeTopic: String = "/testTopic/+"
        let publishTopic: String = "/testTopic/abc"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        let options: BusOptions = BusOptions.init { (message) -> Bool in
            return message.topic.hasSuffix("abcd")
        }
    

        self.bus.subscribe(topic: subscribeTopic, options: options) { (message) in
            expect.fulfill()
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    func testEventBusForceSync() throws {
        if let bus = self.bus as? NotificationEventBus  {
            bus.isForceSync = true
        }
        var testVar = 1
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"

        self.bus.subscribe(topic: subscribeTopic) { (message) in
            testVar = 2
        }
        
        self.bus.publish(topic: publishTopic)
        XCTAssertEqual(testVar, 2)
        
        if let bus = self.bus as? NotificationEventBus  {
            bus.isForceSync = false
        }
    }
}


