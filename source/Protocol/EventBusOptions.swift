//
//  EventBusOption.swift
//  AsyncEventBus
//
//  Created by 王浩沣 on 2021/3/4.
//

import Foundation

public typealias FilterBlock = (BusMessage) -> Bool


@objc
public class BusOptions: NSObject {
    var filter: FilterBlock?
    
    init(filter: FilterBlock?) {
        self.filter = filter
        super.init()
    }
}
