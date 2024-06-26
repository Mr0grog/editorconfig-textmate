//
//  NSWindow+EditorConfig.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2024 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import "ECConstants.h"
#import "NSObject+ECDocument.h"
#import "NSObject+ECSwizzle.h"
#import "NSWindow+EditorConfig.h"

typedef void (*BooleanSetter)(id, SEL, BOOL);
typedef void (*IntegerSetter)(id, SEL, NSUInteger);

@implementation NSWindow (EditorConfig)

+ (void)ec_init {
    [self ec_swizzleMethod:@selector(setRepresentedFilename:)
                withMethod:@selector(ec_setRepresentedFilename:)];
}


#pragma mark - Swizzles/Overrides

- (void)ec_setRepresentedFilename:(NSString *)fileName {
    BOOL shouldNotify = NO;
    if (![[self representedFilename] isEqualToString:fileName]) {
        shouldNotify = YES;
    }
    
    // the original has been swapped with this one; call it
    [self ec_setRepresentedFilename:fileName];
    
    if (shouldNotify) {
        NSDictionary *info = [NSDictionary dictionaryWithObject:self.representedFilename forKey:@"fileName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kECDocumentDidChange
                                                            object:self
                                                          userInfo:info];
    }
}


#pragma mark - View Getters

- (NSView *)ec_statusBar {
    SEL statusBarSelector = @selector(statusBar);
    id controller = self.windowController;
    
    if (controller == nil) {
        controller = self.delegate;
    }
    
    if (controller && [controller respondsToSelector:statusBarSelector]) {
        return [controller performSelector:statusBarSelector];
    }
    
    return nil;
}

- (NSView *)ec_textView {
    SEL textViewSelector = @selector(textView);
    id controller = self.windowController;
    
    if (controller == nil) {
        controller = self.delegate;
    }
    
    if (controller && [controller respondsToSelector:textViewSelector]) {
        return [controller performSelector:textViewSelector];
    }
    
    return nil;
}


#pragma mark - Commands

- (void)ec_setSettings:(ECSettings *)settings forPath:(NSString *)path {
    NSView *textView = self.ec_textView;
    NSObject *document = [textView performSelector:@selector(document)];
    if (document && (!path || [path isEqualToString:[document valueForKey:@"path"]])) {
        document.ec_settings = settings;
    }
}

- (BOOL)ec_setSoftTabs:(BOOL)softTabs {
    BOOL success = NO;
    SEL softTabSelector = @selector(setSoftTabs:);
    
    NSView *textView = self.ec_textView;
    if ([textView respondsToSelector:softTabSelector]) {
        BooleanSetter setter = (BooleanSetter)[textView methodForSelector:softTabSelector];
        setter(textView, softTabSelector, softTabs);
        DebugLog(@"(text view) Setting softabs: %@", softTabs ? @"ON" : @"OFF");
        success = YES;
    }
    
    NSView *statusBar = self.ec_statusBar;
    if ([statusBar respondsToSelector:softTabSelector]) {
        BooleanSetter setter = (BooleanSetter)[statusBar methodForSelector:softTabSelector];
        setter(statusBar, softTabSelector, softTabs);
        DebugLog(@"(status bar) Setting softabs: %@", softTabs ? @"ON" : @"OFF");
    }
    else {
        success = NO;
    }
    
    return success;
}

- (BOOL)ec_setTabSize:(NSUInteger)tabSize {
    BOOL success = NO;
    
    if (tabSize > 0) {
        SEL tabSizeSelector = @selector(setTabSize:);
        
        NSView *textView = self.ec_textView;
        if ([textView respondsToSelector:tabSizeSelector]) {
            IntegerSetter setter = (IntegerSetter)[textView methodForSelector:tabSizeSelector];
            setter(textView, tabSizeSelector, tabSize);
            DebugLog(@"(text view) Setting tab size: %ld", tabSize);
            success = YES;
        }
        
        NSView *statusBar = self.ec_statusBar;
        if ([statusBar respondsToSelector:tabSizeSelector]) {
            IntegerSetter setter = (IntegerSetter)[statusBar methodForSelector:tabSizeSelector];
            setter(statusBar, tabSizeSelector, tabSize);
            DebugLog(@"(status bar) Setting tab size: %ld", tabSize);
        }
        else {
            success = NO;
        }
    }
    
    return success;
}

- (BOOL)ec_setWrapColumn:(NSUInteger)wrapColumn {
    if (wrapColumn == 0) {
        return NO;
    }
    
    NSView *textView = self.ec_textView;
    SEL wrapColumnSelector = @selector(setWrapColumn:);
    
    if ([textView respondsToSelector:wrapColumnSelector]) {
        IntegerSetter setter = (IntegerSetter)[textView methodForSelector:wrapColumnSelector];
        setter(textView, wrapColumnSelector, wrapColumn);
        DebugLog(@"(text view) Setting wrap column: %ld", (long)wrapColumn);
        return YES;
    }
    
    return NO;
}

- (BOOL)ec_setNewline:(NSString *)newlineString {
    NSView *textView = self.ec_textView;
    NSObject *document = [textView performSelector:@selector(document)];
    if (document) {
        document.diskNewlines = newlineString;
        return YES;
    }
    return NO;
}

- (BOOL)ec_setEncoding:(NSString *)encoding {
    NSView *textView = self.ec_textView;
    NSObject *document = [textView performSelector:@selector(document)];
    if (document) {
        document.diskEncoding = encoding;
        return YES;
    }
    return NO;
}


@end
