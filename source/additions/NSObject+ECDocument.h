//
//  NSObject+ECDocument.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2024 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import "ECSettings.h"


/**
 * This category lets us associate EditorConfig settings directly with an
 * OakDocument (TextMate's document class). This allows us to get settings
 * immediately in order to modify documents when they are about to save.
 * 
 * TODO: should this project define an OakDocument interface and add this
 * catgory to that?
 */
@interface NSObject (ECDocument)

@property (nonatomic, copy) ECSettings *ec_settings;
@property (nonatomic) NSString* diskEncoding;
@property (nonatomic) NSString* diskNewlines;

@end
