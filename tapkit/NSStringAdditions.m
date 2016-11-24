//
//  NSStringAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSStringAdditions.h"
#import "TKMacro.h"
#import "NSDataAdditions.h"
#import "NSDictionaryAdditions.h"

@implementation NSString (TapKit)

#pragma mark - Validity

- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet
{
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( ![characterSet characterIsMember:[self characterAtIndex:i]] ) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)hasInCharacterSet:(NSCharacterSet *)characterSet
{
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( [characterSet characterIsMember:[self characterAtIndex:i]] ) {
      return YES;
    }
  }
  return NO;
}



#pragma mark - Finding

- (NSUInteger)locationOfString:(NSString *)string
{
  if ( TK_S_NONEMPTY(string) ) {
    NSRange range = [self rangeOfString:string];
    return range.location;
  }
  return NSNotFound;
}

- (BOOL)containsString:(NSString *)string
{
  return ( [self locationOfString:string]!=NSNotFound );
}



#pragma mark - Hash

- (NSString *)MD5HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}



#pragma mark - URL

- (NSString *)URLEncodedString
{
  CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)self,
                                                                  NULL,
                                                                  CFSTR("!*'();:@&=+$,/?%#[]<>"),
                                                                  kCFStringEncodingUTF8);
  return CFBridgingRelease(stringRef);
}

- (NSString *)URLDecodedString
{
  CFStringRef stringRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                  (__bridge CFStringRef)self,
                                                                                  CFSTR(""),
                                                                                  kCFStringEncodingUTF8);
  return CFBridgingRelease(stringRef);
}


- (NSDictionary *)URLQueryDictionary
{
  NSString *queryString = self;

  if ( [self containsString:@"?"] ) {
    NSUInteger idx = [self locationOfString:@"?"]+1;
    queryString = [self substringFromIndex:idx];
  }

  NSMutableDictionary *queryMap = [[NSMutableDictionary alloc] init];

  NSArray *pairAry = [queryString componentsSeparatedByString:@"&"];
  for ( NSString *pair in pairAry ) {
    NSArray *componentAry = [pair componentsSeparatedByString:@"="];
    if ( [componentAry count]==2 ) {
      NSString *key = [componentAry objectAtIndex:0];
      NSString *value = [[componentAry objectAtIndex:1] URLDecodedString];
      [queryMap setObject:value forKey:key];
    }
  }

  if ( [queryMap count]>0 ) {
    return queryMap;
  }
  return nil;
}

- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)dictionary
{
  NSString *queryString = [dictionary URLQueryString];

  if ( TK_S_NONEMPTY(queryString) ) {

    NSMutableString *string = [[NSMutableString alloc] initWithString:self];

    if ( ![string containsString:@"?"] ) {
      [string appendString:@"?"];
    }

    if ( (![string hasSuffix:@"&"]) && (![string hasSuffix:@"?"]) ) {
      [string appendString:@"&"];
    }

    [string appendString:queryString];

    return string;
  }
  return self;
}

@end
