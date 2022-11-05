//
//  ECSettings.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2022 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ECIndentStyle) {
    ECIndentStyleUnknown,
    ECIndentStyleSpace,
    ECIndentStyleTab
};

/**
 * Stores parsed .editorconfig settings. Property names match the .editorconfig
 * names, but are camel-cased. "Unset" values are nil, 0, or Unknown.
 */
@interface ECSettings : NSObject <NSCopying>

@property ECIndentStyle indentStyle;
@property NSUInteger indentSize;
@property (nonatomic, copy) NSString *endOfLine;
@property (nonatomic, copy) NSString *charset;
@property BOOL trimTrailingWhitespace;
@property BOOL insertFinalNewline;
@property NSUInteger maxLineLength;

/**
 * Read .editorconfig files relevant to the file at `path` and return an
 * ECSettings instance with the correct values.
 */
+ (instancetype)settingsForPath:(NSString *)path;

@end
