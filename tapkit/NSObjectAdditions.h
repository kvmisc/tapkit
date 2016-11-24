//
//  NSObjectAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TapKit)

///-------------------------------
/// Key-Value Coding
///-------------------------------

- (BOOL)isValueForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (BOOL)isValueForKeyPath:(NSString *)keyPath identicalTo:(id)value;

@end
