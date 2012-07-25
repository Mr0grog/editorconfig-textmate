//
//  NSObject+ECSwizzle.m
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+ECSwizzle.h"

@implementation NSObject (ECSwizzle)

+ (void)ec_swizzleMethod:(SEL)original withMethod:(SEL)replacement {
    Method originalMethod = class_getInstanceMethod([self class], original);
    Method replacementMethod = class_getInstanceMethod([self class], replacement);
    method_exchangeImplementations(originalMethod, replacementMethod);
}

@end
