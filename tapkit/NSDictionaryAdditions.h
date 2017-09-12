//
//  NSDictionaryAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (id)objectOrNilForKey:(id)key;

@end



@interface NSMutableDictionary (TapKit)

///-------------------------------
/// Content management
///-------------------------------

- (void)setObject:(id)object forKeyIfNotNil:(id)key;

- (void)removeObjectForKeyIfNotNil:(id)key;

@end
