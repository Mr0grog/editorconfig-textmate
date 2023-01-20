//
//  ECConstants.h
//  editorconfig-textmate
//
//  Copyright (c) 2012-2023 Rob Brackett.
//  This is open source software, released under the MIT license;
//  see the file LICENSE for details.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define DebugLog(format, ...) NSLog((@"EditorConfig: " format), ##__VA_ARGS__)
#else
    #define DebugLog(...)
#endif

extern NSString * const kECDocumentDidChange;
extern NSString * const kECTextViewDidSetDocument;
