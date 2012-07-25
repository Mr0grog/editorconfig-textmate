//
//  ECConstants.h
//  editorconfig-textmate
//
//  Created by Rob Brackett on 7/25/12.
//  Copyright (c) 2012 Rob Brackett. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define DebugLog(format, ...) NSLog((@"EditorConfig: " format), ##__VA_ARGS__)
#else
    #define DebugLog(...)
#endif

extern NSString * const kECDocumentDidChange;
