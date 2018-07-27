//
//  CCTextInputDelegateProxy.h
//  CCNumberKeyboard
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  A proxy object used internanlly by @c CCNumberKeyboard that conveys notifications of pending or transpired changes in text and selection.
 */
@interface CCTextInputDelegateProxy : NSObject

/**
 *  Initializes and returns a proxy delegate object.
 *
 *  An initialized proxy object or @c nil if the proxy could not be initialized.
 *
 *  @param textInput The document object in the application that adopts the @c UITextInput protocol for the purposes of coCCunicating with the text input system.
 *  @param delegate  An input delegate that is notified when text changes or when the selection changes.
 *
 *  @returns An initialized proxy object or @c nil if the proxy could not be initialized.
 */
+ (instancetype)proxyForTextInput:(nullable id <UITextInput>)textInput delegate:(nullable id <UITextInputDelegate>)delegate;

/**
 *  An input delegate that is notified when text changes or when the selection changes.
 *
 *  @note This would normally be a @c CCNumberKeyboard instance.
 */
@property (readonly, nonatomic, weak, nullable) id <UITextInputDelegate> delegate;

/**
 *  The previous input delegate, so that it is also notified when text changes or when the selection changes.
 *
 *  @note This would normally be a system-assigned delegate.
 */
@property (readonly, nonatomic, weak, nullable) id <UITextInputDelegate> previousTextInputDelegate;

@end

NS_ASSUME_NONNULL_END
