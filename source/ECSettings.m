//
//  ECSettings.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2017 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <editorconfig/editorconfig_handle.h>
#import <editorconfig/editorconfig.h>
#import "ECConstants.h"
#import "ECSettings.h"


@implementation ECSettings

#pragma mark - Parsing/instantiation

+ (instancetype)settingsForPath:(NSString *)path {
    ECSettings *settings = [[ECSettings alloc] init];
    
    [self enumerateSettingsForPath:path withBlock:^(NSString *name, NSString *value) {
        if ([name isEqualToString:@"indent_style"]) {
            ECIndentStyle indentStyle = ECIndentStyleUnknown;
            if ([value isEqualToString:@"space"]) {
                indentStyle = ECIndentStyleSpace;
            }
            else if ([value isEqualToString:@"tab"]) {
                indentStyle = ECIndentStyleTab;
            }
            else {
                DebugLog(@"Unknown indent_style value: '%@'", value);
            }
            settings.indentStyle = indentStyle;
        }
        else if ([name isEqualToString:@"indent_size"] || [name isEqualToString:@"tab_width"]) {
            settings.indentSize = [value integerValue];
        }
        else if ([name isEqualToString:@"end_of_line"]) {
            NSString *endOfLine = nil;
            if ([value isEqualToString:@"lf"]) {
                endOfLine = @"\n";
            }
            else if ([value isEqualToString:@"cr"]) {
                endOfLine = @"\r";
            }
            else if ([value isEqualToString:@"crlf"]) {
                endOfLine = @"\r\n";
            }
            else {
                DebugLog(@"Unknown end_of_line value: '%@'", value);
            }
            settings.endOfLine = endOfLine;
        }
        else if ([name isEqualToString:@"charset"]) {
            NSString *charset = nil;
            if ([value isEqualToString:@"latin1"]) {
                charset = @"ISO-8859-1";
            }
            else if ([value isEqualToString:@"utf-8"]) {
                charset = @"UTF-8";
            }
            else if ([value isEqualToString:@"utf-16be"]) {
                charset = @"UTF-16BE";
            }
            else if ([value isEqualToString:@"utf-16le"]) {
                charset = @"UTF-16LE";
            }
            else {
                DebugLog(@"Unknown charset value: '%@'", value);
            }
            settings.charset = charset;
        }
        else if ([name isEqualToString:@"trim_trailing_whitespace"]) {
            settings.trimTrailingWhitespace = [value isEqualToString:@"true"];
        }
        else if ([name isEqualToString:@"insert_final_newline"]) {
            settings.insertFinalNewline = [value isEqualToString:@"true"];
        }
        else if ([name isEqualToString:@"max_line_length"]) {
            settings.indentSize = [value integerValue];
        }
        else {
            DebugLog(@"Unknown setting: '%@'", name);
        }
    }];
        
    return [settings autorelease];
}

+ (void)enumerateSettingsForPath:(NSString *)path withBlock:(void (^)(NSString *name, NSString *value))block {
    editorconfig_handle handle = editorconfig_handle_init();
    int resultCode = editorconfig_parse([path UTF8String], handle);
    if (resultCode == 0) {
        int itemCount = editorconfig_handle_get_name_value_count(handle);
        for (int i = 0; i < itemCount; i++) {
            char const *name;
            char const *value;
            editorconfig_handle_get_name_value(handle, i, &name, &value);
            block([NSString stringWithUTF8String:name],
                  [NSString stringWithUTF8String:value]);
        }
    }
    editorconfig_handle_destroy(handle);
}


#pragma mark - Lifecycle

- (id)init {
    if(self = [super init]) {
        self.indentStyle = ECIndentStyleUnknown;
        self.indentSize = 0;
        self.endOfLine = nil;
        self.charset = nil;
        self.trimTrailingWhitespace = NO;
        self.insertFinalNewline = NO;
        self.maxLineLength = 0;
    }
    return self;
}

- (void)dealloc {
    self.endOfLine = nil;
    self.charset = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    ECSettings *copy = [[self class] allocWithZone:zone];
    
    copy.indentStyle = self.indentStyle;
    copy.indentSize = self.indentSize;
    copy.endOfLine = self.endOfLine;
    copy.charset = self.charset;
    copy.trimTrailingWhitespace = self.trimTrailingWhitespace;
    copy.insertFinalNewline = self.insertFinalNewline;
    copy.maxLineLength = self.maxLineLength;
    
    return copy;
}


@end
