//
//  EditorConfig.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2016 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <editorconfig/editorconfig_handle.h>
#import <editorconfig/editorconfig.h>
#import "ECConstants.h"
#import "NSWindow+EditorConfig.h"
#import "NSView+EditorConfig.h"
#import "ECEditorConfig.h"

@interface ECEditorConfig()

- (void)windowDocumentDidChange:(NSNotification *)notification;
- (void)textViewDidSetDocument:(NSNotification *)notification;

- (void)updateWindow:(NSWindow *)window withConfig:(NSDictionary *)config;
- (NSString *)editorConfigCoreVersion;

@end


@implementation ECEditorConfig

#pragma mark - Lifecycle

- (id)initWithPlugInController:(id <TMPlugInController>)aController {
    if(self = [self init]) {
        DebugLog(@"Initializing EditorConfig-TextMate for TextMate %f with EditorConfig-Core %@.",
                 aController.version,
                 [self editorConfigCoreVersion]);
        
        if (aController.version < 2.0) {
            // Make the window fire a notification when a new document is shown
            [NSWindow ec_init];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(windowDocumentDidChange:)
                                                         name:kECDocumentDidChange
                                                       object:nil];
        }
        else {
            // In TM2, actually showing the document may happen much later than on NSWindow -setRepresentedFile:
            // One example of this is if a window is not frontmost.
            // Instead, we check the actual text view. This is more of a hack, but seems to be the only reliable way.
            Class oakTextView = NSClassFromString(@"OakTextView");
            [oakTextView ec_init];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textViewDidSetDocument:)
                                                         name:kECTextViewDidSetDocument
                                                       object:nil];
        }
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


#pragma mark - Notifications

- (void)windowDocumentDidChange:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    DebugLog(@"File changed to: %@\n  in: %@", [info objectForKey:@"fileName"], [notification object]);
    
    NSDictionary *config = [self configForPath:[info objectForKey:@"fileName"]];
    [self updateWindow:notification.object withConfig:config];
}

- (void)textViewDidSetDocument:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    DebugLog(@"Text View set to: %@\n  in: %@", [info objectForKey:@"fileName"], [notification object]);
    
    NSDictionary *config = [self configForPath:[info objectForKey:@"fileName"]];
    [self updateWindow:[notification.object window] withConfig:config];
}


#pragma mark - Utilities

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
        editorconfig_handle_destroy(handle);
    }
    
    DebugLog(@"Config for %@: %@", filePath, config);
    
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
    
    [window ec_setSettings:config forPath:nil];
    
    // TODO: end_of_line support
}

- (NSString *)editorConfigCoreVersion {
    int ec_version_major, ec_version_minor, ec_version_patch;
    editorconfig_get_version(&ec_version_major,
                             &ec_version_minor,
                             &ec_version_patch);
    return [NSString stringWithFormat:@"%d.%d.%d",
            ec_version_major, ec_version_minor, ec_version_patch];
}

@end
