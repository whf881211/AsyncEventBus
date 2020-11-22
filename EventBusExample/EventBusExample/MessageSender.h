//
//  MessageSender.h
//  EventBusExample
//
//  Created by 王浩沣 on 2020/11/22.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSender : NSObject
- (void)sendMessage:(NSString*)topic;
@end

NS_ASSUME_NONNULL_END
