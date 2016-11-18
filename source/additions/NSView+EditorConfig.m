//
//  NSView+EditorConfig.m
//  editorconfig-textmate
//
//  Copyright (c) 2012 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import "ECConstants.h"
#import "NSObject+ECDocument.h"
#import "NSObject+ECSwizzle.h"
#import "NSView+EditorConfig.h"

@implementation NSView (EditorConfig)

+ (void)ec_init {
    [self ec_swizzleMethod:@selector(setDocument:)
                withMethod:@selector(ec_setDocument:)];
    [self ec_swizzleMethod:@selector(documentWillSave:)
                withMethod:@selector(ec_documentWillSave:)];
}


#pragma mark - Swizzles/Overrides

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

- (void)ec_documentWillSave:(NSNotification*)aNotification {
    [self ec_applySettingsToDocument:aNotification.object];
    [self ec_documentWillSave:aNotification];
}


#pragma mark - Private

- (void)ec_applySettingsToDocument:(NSObject *)document {
    NSDictionary *settings = document.ec_settings;
    BOOL insertFinalNewline = [[settings objectForKey:@"insert_final_newline"] isEqualToString:@"true"];
    BOOL trimTrailingWhitespace = [[settings objectForKey:@"trim_trailing_whitespace"] isEqualToString:@"true"];
    
    if (!(insertFinalNewline || trimTrailingWhitespace)) {
        return;
    }
    
    BOOL didChangeContent = NO;
    NSString *content = [document performSelector:@selector(content)];
    NSString *lineTerminator = [document performSelector:@selector(diskNewlines)];
    if (!lineTerminator) {
        lineTerminator = @"\n";
    }
    
    if (insertFinalNewline && ![content hasSuffix:lineTerminator]) {
        content = [content stringByAppendingString:lineTerminator];
        didChangeContent = YES;
    }
    
    if (trimTrailingWhitespace) {
        // TODO: implement trim_trailing_whitespace
    }
    
    if (didChangeContent) {
        [document performSelector:@selector(setContent:) withObject:content];
    }
}

@end
