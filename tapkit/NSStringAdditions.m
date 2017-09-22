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

- (BOOL)tk_isInCharacterSet:(NSCharacterSet *)characterSet
{
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( ![characterSet characterIsMember:[self characterAtIndex:i]] ) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)tk_hasInCharacterSet:(NSCharacterSet *)characterSet
{
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( [characterSet characterIsMember:[self characterAtIndex:i]] ) {
      return YES;
    }
  }
  return NO;
}



#pragma mark - Finding

- (NSUInteger)tk_locationOfString:(NSString *)string
{
  if ( TK_S_NONEMPTY(string) ) {
    NSRange range = [self rangeOfString:string];
    return range.location;
  }
  return NSNotFound;
}

- (BOOL)tk_containsString:(NSString *)string
{
  return ( [self tk_locationOfString:string]!=NSNotFound );
}



#pragma mark - Hash

- (NSString *)tk_MD5HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] tk_MD5HashString];
}

- (NSString *)tk_SHA1HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] tk_SHA1HashString];
}

@end
