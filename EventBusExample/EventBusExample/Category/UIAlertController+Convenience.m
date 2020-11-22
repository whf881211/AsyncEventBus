//
//  UIAlertController+WSConvenience.m
//  microvision
//
//  Created by ryanhfwang on 2020/4/20.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "UIAlertController+Convenience.h"
#import <objc/runtime.h>

@interface  WSAlertAssistViewController : UIViewController
@end

@implementation WSAlertAssistViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

@end

@interface UIAlertController ()
//alertController会使用的window
@property(nonatomic,strong) UIWindow* alertControllerWindow;
@end


@implementation UIAlertController (Convenience)

//associate 变量
- (void)setAlertControllerWindow:(UIWindow *)alertControllerWindow {
    objc_setAssociatedObject(self, @selector(alertControllerWindow), alertControllerWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertControllerWindow {
    UIWindow * window = objc_getAssociatedObject(self, @selector(alertControllerWindow));
    if (!window) {
        window =  [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self setAlertControllerWindow:window];
    }
    return window;
}

//单按钮
+ (void)showAlertControllerWithTheButton:(NSString *)buttonTitle
                                 message:(NSString *)message
                                   title:(NSString *)title {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController setActionWithButton:buttonTitle buttonHandler:nil cancelTitle:nil cancelHandelr:nil];
    [alertController show];
}

//双按钮
+ (void)showAlertControllerWithTitle:(NSString*)title
                             message:(NSString*)message
                              button:(NSString*)btnTitle
                             handler:(void (^)(UIAlertAction *  alertAction))handler
                        cancelButton:(NSString*)cancelBtnTitle
                       cancelHandler:(void (^)(UIAlertAction *  alertAction))cancelHandler {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController setActionWithButton:btnTitle buttonHandler:handler cancelTitle:cancelBtnTitle cancelHandelr:cancelHandler];
    [alertController show];
}
//设置按钮事件
- (void)setActionWithButton:(NSString*)title
              buttonHandler:(void (^)(UIAlertAction * alertAction))handler
                cancelTitle:(NSString*)cancelTitle
              cancelHandelr:(void (^)(UIAlertAction *  alertAction))cancelHandler {
    //处理cancel按钮
    __weak typeof(self) _self = self;
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:cancelTitle
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(self) self = _self;
            if(cancelHandler) {
                cancelHandler(action);
            }
            [self removeWindow];
        }];
        [self addAction:cancelAction];
    }
    //处理普通按钮
    if (title) {
        UIAlertAction *buttonAction = [UIAlertAction
                                       actionWithTitle:title
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(self) self = _self;
            if(handler) {
                handler(action);
            }
            [self removeWindow];
        }];
        [self addAction:buttonAction];
    }
}


- (void)show {
    //展现window
    __weak typeof(self) weakAlertController = self;
    
    WSAlertAssistViewController* tempViewController =   [[WSAlertAssistViewController alloc]init];
    [self.alertControllerWindow setRootViewController:tempViewController];
    [self.alertControllerWindow setWindowLevel:UIWindowLevelAlert];
    self.alertControllerWindow.hidden = NO;
    [tempViewController presentViewController:weakAlertController animated:YES completion:nil];
}

- (void)removeWindow {
    [self.alertControllerWindow setHidden:YES];
    self.alertControllerWindow = nil;
}

@end
