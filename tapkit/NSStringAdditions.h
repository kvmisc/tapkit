//
//  NSStringAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TapKit)

///-------------------------------
/// Validity
///-------------------------------

- (BOOL)tk_isInCharacterSet:(NSCharacterSet *)characterSet;

- (BOOL)tk_hasInCharacterSet:(NSCharacterSet *)characterSet;


///-------------------------------
/// Finding
///-------------------------------

- (NSUInteger)tk_locationOfString:(NSString *)string;

- (BOOL)tk_containsString:(NSString *)string;


///-------------------------------
/// Hash
///-------------------------------

- (NSString *)tk_MD5HashString;

- (NSString *)tk_SHA1HashString;

@end
