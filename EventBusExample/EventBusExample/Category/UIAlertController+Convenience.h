//
//  UIAlertController+WSConvenience.h
//  microvision
//
//  Created by ryanhfwang on 2020/4/20.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIAlertController (Convenience)

//单按钮
+(void)showAlertControllerWithTheButton:(NSString *)buttonTitle
                                message:(nullable NSString *)message
                                  title:(nullable NSString *)title;

//双按钮
+(void)showAlertControllerWithTitle:(nullable NSString*)title
                            message:(nullable NSString*)message
                             button:(nullable NSString*)btnTitle
                            handler:(void (^ __nullable)(UIAlertAction * alertAction))handler
                       cancelButton:(nullable NSString *)cancelBtnTitle
                      cancelHandler:(void (^ __nullable)(UIAlertAction * alertAction))cancelHandler;


-(void)show;

@end
NS_ASSUME_NONNULL_END


