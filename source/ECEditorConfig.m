//
//  EditorConfig.m
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
    
    ECSettings *config = [ECSettings settingsForPath:[info objectForKey:@"fileName"]];
    [self updateWindow:notification.object withConfig:config];
}

- (void)textViewDidSetDocument:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    DebugLog(@"Text View set to: %@\n  in: %@", [info objectForKey:@"fileName"], [notification object]);
    
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
