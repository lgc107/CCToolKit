//
//  NSObject+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/7/14.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSObject+Extensions.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation NSObject (Utilities)

+ (NSString *)cc_className{
     return NSStringFromClass(self);
}

- (NSString *)cc_className{
     return [NSString stringWithUTF8String:class_getName([self class])];
}

- (id)cc_deepCopy {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}
@end

@implementation NSObject (Runtime)

+ (BOOL)cc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)cc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}


- (void)cc_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cc_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)cc_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)cc_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}
@end


@implementation NSObject (KVO)


@end
