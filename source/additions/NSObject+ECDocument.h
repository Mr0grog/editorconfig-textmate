//
//  NSObject+ECDocument.h
//  editorconfig-textmate
//
//  Copyright © 2016 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import "ECSettings.h"


/**
 * This category lets us associate EditorConfig settings directly with an
 * OakDocument (TextMate's document class). This allows us to get settings
 * immediately in order to modify documents when they are about to save.
 */
@interface NSObject (ECDocument)

@property (nonatomic, copy) ECSettings *ec_settings;

@end
