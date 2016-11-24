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

- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet;

- (BOOL)hasInCharacterSet:(NSCharacterSet *)characterSet;


///-------------------------------
/// Finding
///-------------------------------

- (NSUInteger)locationOfString:(NSString *)string;

- (BOOL)containsString:(NSString *)string;


///-------------------------------
/// Hash
///-------------------------------

- (NSString *)MD5HashString;

- (NSString *)SHA1HashString;


///-------------------------------
/// URL
///-------------------------------

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;


- (NSDictionary *)URLQueryDictionary;

- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)dictionary;

@end
