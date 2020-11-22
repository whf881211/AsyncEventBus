//
//  ViewController.m
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/7.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

#import "ViewController.h"
#import "EventBusExample-Swift.h"
#import "MessageSender.h"
#import "MessageReceiver.h"
@interface ViewController ()
@property(nonatomic, strong) MessageSender *sender;
@property(nonatomic, strong) MessageReceiver *receiver;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _sender = [MessageSender new];
        _receiver = [MessageReceiver new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_sender sendMessage:@"/test/a"];
}


@end
