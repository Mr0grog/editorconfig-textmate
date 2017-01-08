//
//  NSObject+ECDocument.m
//  editorconfig-textmate
//
//  Copyright © 2016 Rob Brackett
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <objc/runtime.h>
#import "NSObject+ECDocument.h"

@implementation NSObject (ECDocument)

// These are defined in OakDocument
@dynamic diskEncoding;
@dynamic diskNewlines;

- (void)setEc_settings:(ECSettings *)ec_settings {
    objc_setAssociatedObject(self, @selector(ec_settings), ec_settings, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ECSettings *)ec_settings {
    id settings = objc_getAssociatedObject(self, @selector(ec_settings));
    if (![settings isKindOfClass:[ECSettings class]]) {
        settings = nil;
    }
    return settings;
}

@end
