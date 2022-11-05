//
//  NSWindow+EditorConfig.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2022 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Cocoa/Cocoa.h>
#import "ECSettings.h"

// Because TM doesn't have a nice API, we have to mess with NSWindow :(
@interface NSWindow (EditorConfig)

// This MUST be called at plugin initialization time; it swizzles things.
+ (void)ec_init;

// Replacement for setRepresentedFilename
// sends a kECDocumentDidChange notification
- (void)ec_setRepresentedFilename:(NSString *)fileName;

- (void)ec_setSettings:(ECSettings *)settings forPath:(NSString *)path;

- (BOOL)ec_setSoftTabs:(BOOL)softTabs;
- (BOOL)ec_setTabSize:(NSUInteger)tabSize;
- (BOOL)ec_setWrapColumn:(NSUInteger)wrapColumn;
- (BOOL)ec_setNewline:(NSString *)newlineString;
- (BOOL)ec_setEncoding:(NSString *)encoding;

@end
