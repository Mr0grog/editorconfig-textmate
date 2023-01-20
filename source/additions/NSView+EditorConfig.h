//
//  NSView+EditorConfig.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2023 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//



@interface NSView (EditorConfig)

// This MUST be called at plugin initialization time; it swizzles things.
+ (void)ec_init;

- (void)ec_setDocument:(id)document;
- (void)ec_documentWillSave:(NSNotification*)aNotification;

@end
