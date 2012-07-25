//
//  EditorConfig.m
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import "editorconfig_handle.h"
#import "editorconfig.h"

#import "ECConstants.h"
#import "NSWindow+EditorConfig.h"
#import "EditorConfig.h"

@interface EditorConfig()

- (void)documentDidChange:(NSNotification *)notification;

- (void)updateWindow:(NSWindow *)window withConfig:(NSDictionary *)config;

@end


@implementation EditorConfig

#pragma mark Lifecycle

- (id)initWithPlugInController:(id <TMPlugInController>)aController {
    if(self = [self init]) {
        [NSWindow ec_init];
        
        // Notification from our custom NSWindow for when a new document is shown in a window
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentDidChange:)
                                                     name:kECDocumentDidChange
                                                   object:nil];
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


#pragma mark Notifications

- (void)documentDidChange:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    DebugLog(@"File changed to: %@\n  in: %@", [info objectForKey:@"fileName"], [notification object]);
    
    NSDictionary *config = [self configForPath:[info objectForKey:@"filename"]];
    [self updateWindow:notification.object withConfig:config];
}


#pragma mark Utilities

- (NSDictionary *)configForPath:(NSString *)filePath {
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    
    if (filePath) {
        editorconfig_handle handle = editorconfig_handle_init();
        int resultCode = editorconfig_parse([filePath UTF8String], handle);
        if (resultCode == 0) {
            int itemCount = editorconfig_handle_get_name_value_count(handle);
            for (int i = 0; i < itemCount; i++) {
                char const *name;
                char const *value;
                editorconfig_handle_get_name_value(handle, i, &name, &value);
                [config setValue:[NSString stringWithUTF8String:value] forKey:[NSString stringWithUTF8String:name]];
            }
        }
    }
    
    return [[config copy] autorelease];
}

- (NSDictionary *)configForURL:(NSURL *)fileURL {
    return [self configForPath:[fileURL path]];
}

- (void)updateWindow:(NSWindow *)window withConfig:(NSDictionary *)config {
    NSString *indent_style = [config objectForKey:@"indent_style"];
    if (indent_style) {
        [window ec_setSoftTabs:[indent_style isEqualToString:@"space"]];
    }
    
    // TM doesn't differentiate between tab- and space-indent sizes
    NSString *sizeKey = [indent_style isEqualToString:@"tab"] ? @"tab_width" : @"indent_size";
    NSString *indent_size = [config objectForKey:sizeKey];
    if (indent_size) {
        [window ec_setTabSize:[indent_size intValue]];
    }
    
    // TODO: end_of_line support
}

@end
