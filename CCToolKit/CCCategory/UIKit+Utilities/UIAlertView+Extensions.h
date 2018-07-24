//
//  UIAlertView+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/7/24.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewActionButtonBlock) (NSInteger buttonIndex);

typedef void(^UIAlertViewActionCancelBlock) (void);

@interface UIAlertView (Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteAction:(UIAlertViewActionButtonBlock)completeAction CancelAction:(UIAlertViewActionCancelBlock)cancelAction;

@end


