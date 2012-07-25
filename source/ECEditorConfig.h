//
//  EditorConfig.h
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TMPlugInController.h"

@interface ECEditorConfig : NSObject

- (id)initWithPlugInController:(id <TMPlugInController>)aController;

- (NSDictionary *)configForPath:(NSString *)filePath;
- (NSDictionary *)configForURL:(NSURL *)fileURL;

@end
