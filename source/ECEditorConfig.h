//
//  EditorConfig.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2016 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Cocoa/Cocoa.h>
#import "TMPlugInController.h"

@interface ECEditorConfig : NSObject

- (id)initWithPlugInController:(id <TMPlugInController>)aController;

- (NSDictionary *)configForPath:(NSString *)filePath;
- (NSDictionary *)configForURL:(NSURL *)fileURL;

@end
