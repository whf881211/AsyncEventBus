//
//  MessageReceiver.m
//  EventBusExample
//
//  Created by 王浩沣 on 2020/11/22.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

#import "MessageReceiver.h"
#import "EventBusExample-Swift.h"
#import "UIAlertController+Convenience.h"

@implementation MessageReceiver
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self subscribe];
    }
    return self;
}

- (void)subscribe {
    [self.bus subscribeTopic:@"/test/a" action:^(id<BusMessageRepresentable> _Nonnull msg) {
        [UIAlertController showAlertControllerWithTheButton:@"ok" message:@"/test/a" title:[NSString stringWithFormat:@"reveive: %@",msg.topic]];
    }];
    
    id<SubscribeDisposable> observe = [self.bus subscribeTopic:@"/test/+" action:^(id<BusMessageRepresentable> _Nonnull msg) {
        [UIAlertController showAlertControllerWithTheButton:@"ok" message:@"/test/+" title:[NSString stringWithFormat:@"reveive: %@",msg.topic]];
    }];
    
    [observe unsubscribe];
}
@end
