//
//  CCTextInputDelegateProxy.m
//  CCNumberKeyboard
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCTextInputDelegateProxy.h"

@implementation CCTextInputDelegateProxy

+ (instancetype)proxyForTextInput:(id<UITextInput>)textInput delegate:(id<UITextInputDelegate>)delegate
{
    NSParameterAssert(delegate);
    
    CCTextInputDelegateProxy *proxy = [[CCTextInputDelegateProxy alloc] init];
    proxy->_delegate = delegate;
    proxy->_previousTextInputDelegate = textInput.inputDelegate;
    
    return proxy;
}

#pragma mark - Forwarding.

- (NSArray *)delegates
{
    NSMutableArray *delegates = [NSMutableArray array];
    
    id <UITextInputDelegate> previousTextInputDelegate = self.previousTextInputDelegate;
    if (previousTextInputDelegate) {
        [delegates addObject:previousTextInputDelegate];
    }
    
    id <UITextInputDelegate> delegate = self.delegate;
    if (delegate) {
        [delegates addObject:delegate];
    }
    
    return [delegates copy];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        for (id delegate in self.delegates) {
            if ([delegate respondsToSelector:aSelector]) {
                return [delegate methodSignatureForSelector:aSelector];
            }
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}

@end
