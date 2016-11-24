//
//  NSObjectAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSObjectAdditions.h"
#import "TKMacro.h"

@implementation NSObject (TapKit)

#pragma mark - Key-Value Coding

- (BOOL)isValueForKeyPath:(NSString *)keyPath equalTo:(id)value
{
  if ( TK_S_NONEMPTY(keyPath) ) {
    id aValue = [self valueForKeyPath:keyPath];

    if ( (!aValue) && (!value) ) {
      return YES;
    }

    return [aValue isEqual:value];
  }
  return NO;
}

- (BOOL)isValueForKeyPath:(NSString *)keyPath identicalTo:(id)value
{
  if ( TK_S_NONEMPTY(keyPath) ) {
    return ( [self valueForKeyPath:keyPath]==value );
  }
  return NO;
}

@end
