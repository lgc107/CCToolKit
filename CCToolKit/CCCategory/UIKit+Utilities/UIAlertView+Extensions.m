//
//  UIAlertView+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/7/24.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "UIAlertView+Extensions.h"
#import <objc/runtime.h>


@implementation UIAlertView (Block)

static void *button = "AlertButtonAction";
static void *cancel = "CancelButtonAction";

- (void)showAlertViewWithCompleteAction:(UIAlertViewActionButtonBlock)completeAction CancelAction:(UIAlertViewActionCancelBlock)cancelAction{
    if (completeAction) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, button, completeAction, OBJC_ASSOCIATION_COPY);
        objc_setAssociatedObject(self, cancel, cancelAction, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
        
    }
    [self show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ///获取关联的对象，通过关键字。
    UIAlertViewActionButtonBlock completition = objc_getAssociatedObject(self, button);
    if (completition) {
        ///block传值
        completition(buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    ///获取关联的对象，通过关键字。
    UIAlertViewActionCancelBlock cancelAction = objc_getAssociatedObject(self, cancel);
    if (cancelAction) {
        ///block传值
        cancelAction();
    }
}

@end
