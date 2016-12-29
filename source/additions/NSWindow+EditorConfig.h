//
//  NSWindow+EditorConfig.h
//  editorconfig-textmate
//
//  Copyright (c) 2012 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Cocoa/Cocoa.h>

// Because TM doesn't have a nice API, we have to mess with NSWindow :(
@interface NSWindow (EditorConfig)

// This MUST be called at plugin initialization time; it swizzles things.
+ (void)ec_init;

// Replacement for setRepresentedFilename
// sends a kECDocumentDidChange notification
- (void)ec_setRepresentedFilename:(NSString *)fileName;

- (void)ec_setSettings:(NSDictionary *)settings forPath:(NSString *)path;

- (BOOL)ec_setSoftTabs:(BOOL)softTabs;
- (BOOL)ec_setTabSize:(int)tabSize;
- (BOOL)ec_setWrapColumn:(int)wrapColumn;

@end
