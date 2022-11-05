//
//  NSView+EditorConfig.m
//  editorconfig-textmate
//
//  Copyright (c) 2012-2022 Rob Brackett.
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
    ECSettings *settings = document.ec_settings;
    if (!(settings.insertFinalNewline || settings.trimTrailingWhitespace)) {
        return;
    }
    
    BOOL didChangeContent = NO;
    BOOL didUpdateSelection = NO;
    NSMutableArray<NSValue *> *selections;
    NSString *content = [document performSelector:@selector(content)];
    NSString *lineTerminator = [document performSelector:@selector(diskNewlines)];
    if (!lineTerminator) {
        lineTerminator = @"\n";
    }
    
    if (settings.insertFinalNewline && ![content hasSuffix:lineTerminator]) {
        content = [content stringByAppendingString:lineTerminator];
        didChangeContent = YES;
    }
    
    // TODO: find a reasonable way to encapsulate all the logic here.
    if (settings.trimTrailingWhitespace) {
        NSMutableString *newContent = [NSMutableString string];
        // Selections are an NSArray of NSValues boxing NSRanges
        // FIXME: this approach collapses column selections into a single contiguous range. Not sure on a better approach for now.
        // http://lists.macromates.com/textmate/2017-January/040185.html
        selections = [self accessibilityAttributeValue:NSAccessibilitySelectedTextRangesAttribute];
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        NSCharacterSet *newline = [NSCharacterSet newlineCharacterSet];
        NSScanner *scanner = [NSScanner scannerWithString:content];
        // By default scanners skip newlines and whitespace -- exactly what we're scaning for :P
        scanner.charactersToBeSkipped = nil;
        
        NSString *line;
        NSUInteger currentIndex = 0;
        while (!scanner.isAtEnd) {
            if ([scanner scanUpToCharactersFromSet:newline intoString:&line]) {
                NSUInteger i = 0;
                for (i = line.length; i > 0; i--) {
                    if (![whitespace characterIsMember:[line characterAtIndex:i - 1]]) {
                        break;
                    }
                }
                
                [newContent appendString:[line substringToIndex:i]];
                
                NSUInteger removedOnThisLine = line.length - i;
                currentIndex += i;
                
                if (removedOnThisLine > 0) {
                    didChangeContent = YES;
                    
                    for (NSUInteger selectionIndex = 0; selectionIndex < selections.count; selectionIndex++) {
                        NSRange selection = [[selections objectAtIndex:selectionIndex] rangeValue];
                        NSUInteger selectionEnd = NSMaxRange(selection);
                        if (selectionEnd > currentIndex) {
                            NSUInteger newLocation = selection.location;
                            
                            if (selection.location >= currentIndex + removedOnThisLine) {
                                newLocation -= removedOnThisLine;
                            }
                            else if (selection.location > currentIndex) {
                                newLocation = currentIndex;
                            }
                            
                            if (selectionEnd >= currentIndex + removedOnThisLine) {
                                selectionEnd -= removedOnThisLine;
                            }
                            else {
                                selectionEnd = currentIndex;
                            }
                            
                            selection = NSMakeRange(newLocation, selectionEnd - newLocation);
                            [selections replaceObjectAtIndex:selectionIndex withObject:[NSValue valueWithRange:selection]];
                            didUpdateSelection = YES;
                        }
                    }
                }
            }
            
            if ([scanner scanCharactersFromSet:newline intoString:&line]) {
                [newContent appendString:line];
                currentIndex += line.length;
            }
        }
        
        content = newContent;
    }
    
    if (didChangeContent) {
        [document performSelector:@selector(setContent:) withObject:content];
    }
    if (didUpdateSelection) {
        [self accessibilitySetValue:selections forAttribute:NSAccessibilitySelectedTextRangesAttribute];
    }
}

@end
