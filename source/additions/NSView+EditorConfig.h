//
//  NSView+EditorConfig.h
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/27/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//



@interface NSView (EditorConfig)

// This MUST be called at plugin initialization time; it swizzles things.
+ (void)ec_init;

- (void)ec_setDocument:(id)document;

@end
