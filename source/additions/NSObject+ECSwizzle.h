//
//  NSObject+ECSwizzle.h
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ECSwizzle)

// Really simple swizzling
// Add a method to the class with a category and swizzle that selector
+ (void)ec_swizzleMethod:(SEL)original withMethod:(SEL)replacement;

@end
