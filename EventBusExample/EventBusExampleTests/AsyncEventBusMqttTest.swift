//
//  EventBusTest.swift
//  EventBusExampleTests
//
//  Created by ryanhfwang on 2021/2/18.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//
import XCTest
@testable import AsyncEventBus

class AsyncEventBusMqttTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func subscribeTest(topic: String, expect: XCTestExpectation) {
        self.bus.subscribe(topic: topic) { (message) in
            expect.fulfill()
        }
    }
    
    func publishTest(topic: String, expect: XCTestExpectation) {
        self.bus.publish(topic: topic)
        self.wait(for: [expect], timeout: 1)
    }
    
    
    //测试同topic
    func testEventBusMqtt_SameTopic() throws {
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
       
    }
    
    //测试不同topic
    func testEventBusMqtt_SameTopic1() throws {
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopicAAA"

        let expect: XCTestExpectation = XCTestExpectation.init()
        
        expect.isInverted = true
        
        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)       
    }
    
    //测试#匹配符
    func testEventBusMqtt_PoundTopic1() throws {
        
        let subscribeTopic: String = "/#"
        let publishTopic: String = "/a"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }
    
    //测试#匹配符
    func testEventBusMqtt_PoundTopic2() throws {
        
        let subscribeTopic: String = "/a/b/#"
        let publishTopic: String = "/a/b/c"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }
   
    
    //测试#匹配符
    func testEventBusMqtt_PoundTopic3() throws {
        
        let subscribeTopic: String = "/a/b/#"
        let publishTopic: String = "/a/b/c/d/e"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }
    
    //测试#匹配符
    func testEventBusMqtt_PoundTopic4() throws {
        
        let subscribeTopic: String = "/a/b/#"
        let publishTopic: String = "/a/b"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }
    
    //测试+匹配符
    func testEventBusMqtt_PlusTopic1() throws {
        let subscribeTopic: String = "/a/+"
        let publishTopic: String = "/a/b"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }
    
    //测试+匹配符
    func testEventBusMqtt_PlusTopic2() throws {
        let subscribeTopic: String = "/a/+/c"
        let publishTopic: String = "/a/b/c"

        let expect: XCTestExpectation = XCTestExpectation.init()

        self.subscribeTest(topic: subscribeTopic, expect: expect)
        self.publishTest(topic: publishTopic, expect: expect)
    }



}
