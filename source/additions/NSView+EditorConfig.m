//
//  NSView+EditorConfig.m
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/27/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import "ECConstants.h"
#import "NSObject+ECSwizzle.h"
#import "NSView+EditorConfig.h"

@implementation NSView (EditorConfig)

+ (void)ec_init {
    [self ec_swizzleMethod:@selector(setDocument:)
                withMethod:@selector(ec_setDocument:)];
}

- (void)ec_setDocument:(id)document {
    [self ec_setDocument:document];
    
    NSString *fileName = [document valueForKey:@"path"];
    if (fileName == nil) {
        fileName = self.window.representedFilename;
        if (fileName == nil) {
            fileName = [self.window.windowController representedFilename];
            if (fileName == nil) {
                fileName = @"";
            }
        }
    }
    
    NSDictionary *info = [NSDictionary dictionaryWithObject:fileName forKey:@"fileName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kECTextViewDidSetDocument
                                                        object:self
                                                      userInfo:info];
}

@end
