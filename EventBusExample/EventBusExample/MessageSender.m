//
//  MessageSender.m
//  EventBusExample
//
//  Created by 王浩沣 on 2020/11/22.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

#import "MessageSender.h"
#import "EventBusExample-Swift.h"


@implementation MessageSender
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)sendMessage:(NSString*)topic {
    [self.bus publishTopic:topic];
}
@end
