//
//  NSWindow+EditorConfig.m
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import "ECConstants.h"
#import "NSObject+ECSwizzle.h"
#import "NSWindow+EditorConfig.h"

@implementation NSWindow (EditorConfig)

+ (void)ec_init {
    [self ec_swizzleMethod:@selector(setRepresentedFilename:)
                withMethod:@selector(ec_setRepresentedFilename:)];
}

- (void)ec_setRepresentedFilename:(NSString *)fileName {
    BOOL shouldNotify = NO;
    if (![[self representedFilename] isEqualToString:fileName]) {
        shouldNotify = YES;
    }
    
    // the original has been swapped with this one; call it
    [self ec_setRepresentedFilename:fileName];
    
    if (shouldNotify) {
        NSDictionary *info = [NSDictionary dictionaryWithObject:self.representedFilename forKey:@"fileName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kECDocumentDidChange
                                                            object:self
                                                          userInfo:info];
    }
}

- (BOOL)ec_setSoftTabs:(BOOL)softTabs {
    SEL textViewSelector = @selector(textView);
    SEL softTabSelector = @selector(setSoftTabs:);
    
    NSWindowController *controller = self.windowController;
    if ([controller respondsToSelector:textViewSelector]) {
        id textView = [controller performSelector:textViewSelector];
        if ([textView respondsToSelector:softTabSelector]) {
            IMP setter = [textView methodForSelector:softTabSelector];
            setter(textView, softTabSelector, softTabs);
            DebugLog(@"Setting softabs: %@", softTabs ? @"ON" : @"OFF");
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)ec_setTabSize:(int)tabSize {
    if (tabSize > 0) {
        SEL textViewSelector = @selector(textView);
        SEL tabSizeSelector = @selector(setTabSize:);
        
        NSWindowController *controller = self.windowController;
        if ([controller respondsToSelector:textViewSelector]) {
            id textView = [controller performSelector:textViewSelector];
            if ([textView respondsToSelector:tabSizeSelector]) {
                IMP setter = [textView methodForSelector:tabSizeSelector];
                setter(textView, tabSizeSelector, tabSize);
                DebugLog(@"Setting tabsize: %d", tabSize);
                return YES;
            }
        }
    }
    
    return NO;
}

@end
