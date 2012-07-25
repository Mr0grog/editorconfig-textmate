//
//  NSWindow+EditorConfig.h
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Because TM doesn't have a nice API, we have to mess with NSWindow :(
@interface NSWindow (EditorConfig)

// This MUST be called at plugin initialization time; it swizzles things.
+ (void)ec_init;

// Replacement for setRepresentedFilename
// sends a kECDocumentDidChange notification
- (void)ec_setRepresentedFilename:(NSString *)fileName;

- (BOOL)ec_setSoftTabs:(BOOL)softTabs;
- (BOOL)ec_setTabSize:(int)tabSize;

@end
