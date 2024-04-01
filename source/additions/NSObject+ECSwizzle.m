//
//  NSObject+ECSwizzle.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2024 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
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
