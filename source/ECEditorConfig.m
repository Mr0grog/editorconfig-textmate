//
//  EditorConfig.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2024 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <editorconfig/editorconfig_handle.h>
#import <editorconfig/editorconfig.h>
#import "ECConstants.h"
#import "ECSettings.h"
#import "NSWindow+EditorConfig.h"
#import "NSView+EditorConfig.h"
#import "ECEditorConfig.h"

@interface ECEditorConfig()

- (void)windowDocumentDidChange:(NSNotification *)notification;
- (void)textViewDidSetDocument:(NSNotification *)notification;

- (void)updateWindow:(NSWindow *)window withConfig:(ECSettings *)config;
- (NSString *)editorConfigCoreVersion;

@end


@implementation ECEditorConfig

#pragma mark - Lifecycle

- (id)initWithPlugInController:(id <TMPlugInController>)aController {
    if(self = [self init]) {
        if (aController.version >= 2.0) {
            DebugLog(@"Initializing EditorConfig-TextMate for TextMate %f with EditorConfig-Core %@.",
                     aController.version,
                     [self editorConfigCoreVersion]);
            
            // Add notifications to the text view so we know when a new document
            // is shown. (Note: NSWindow -setRepresentedFile: would be much
            // easier, but does not actually have the correct timing with when
            // that document is actually loaded and shown.)
            Class oakTextView = NSClassFromString(@"OakTextView");
            [oakTextView ec_init];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textViewDidSetDocument:)
                                                         name:kECTextViewDidSetDocument
                                                       object:nil];
        }
        else {
            // Log in production builds so users can find this message
            NSLog(@"EditorConfig-TextMate is not compatible with TextMate v%f.",
                  aController.version);
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
    
    ECSettings *config = [ECSettings settingsForPath:[info objectForKey:@"fileName"]];
    [self updateWindow:notification.object withConfig:config];
}

- (void)textViewDidSetDocument:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    
    ECSettings *config = [ECSettings settingsForPath:[info objectForKey:@"fileName"]];
    [self updateWindow:[notification.object window] withConfig:config];
}


#pragma mark - Utilities

- (void)updateWindow:(NSWindow *)window withConfig:(ECSettings *)config {
    if (config.indentStyle != ECIndentStyleUnknown) {
        [window ec_setSoftTabs:(config.indentStyle == ECIndentStyleSpace)];
    }
    
    if (config.indentSize > 0) {
        [window ec_setTabSize:config.indentSize];
    }
    
    if (config.maxLineLength > 0) {
        [window ec_setWrapColumn:config.maxLineLength];
    }
    
    if (config.endOfLine) {
        [window ec_setNewline:config.endOfLine];
    }
    
    if (config.charset) {
        [window ec_setEncoding:config.charset];
    }
    
    [window ec_setSettings:config forPath:nil];
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
