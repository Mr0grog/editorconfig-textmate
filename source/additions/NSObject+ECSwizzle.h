//
//  NSObject+ECSwizzle.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2024 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Foundation/Foundation.h>

@interface NSObject (ECSwizzle)

// Really simple swizzling
// Add a method to the class with a category and swizzle that selector
+ (void)ec_swizzleMethod:(SEL)original withMethod:(SEL)replacement;

@end
