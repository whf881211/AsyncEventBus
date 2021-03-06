//
//  EventBusLogPrinterProtocol.swift
//  AsyncEventBus
//
//  Created by ryanhfwang on 2021/3/3.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import Foundation

///LogPrinter
///
///
@objc public protocol LogPrinter {
    func print(info: String)
}
