//
//  ExampleViewController.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2021/3/4.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation
import UIKit

class ExampleViewController: UIViewController {
    func test() {
        self.bus.subscribe(topic: "/topic/a") { (message) in
            // do sth after receive published meesage
            
            //then you could reply to publisher
            message.reply(payload: nil)
        }
        
        self.bus.publish(topic: "/topic", payload: nil) { (message) in
            // do sth after subscriber's reply
        }
    }
    
}
