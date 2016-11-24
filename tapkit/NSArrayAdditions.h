//
//  NSArrayAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (id)objectOrNilAtIndex:(NSUInteger)idx;

- (id)randomObject;


- (BOOL)hasObjectEqualTo:(id)object;

- (BOOL)hasObjectIdenticalTo:(id)object;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (NSArray *)objectsForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (NSArray *)objectsForKeyPath:(NSString *)keyPath identicalTo:(id)value;


- (id)objectForKeyPath:(NSString *)keyPath equalTo:(id)value;

- (id)objectForKeyPath:(NSString *)keyPath identicalTo:(id)value;

@end



@interface NSMutableArray (TapKit)

///-------------------------------
/// Content management
///-------------------------------

- (id)addObjectIfNotNil:(id)object;

- (id)addUnequalObjectIfNotNil:(id)object;

- (id)addUnidenticalObjectIfNotNil:(id)object;

- (id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx;


- (void)removeFirstObject;


///-------------------------------
/// Ordering
///-------------------------------

- (void)shuffle;

- (void)reverse;

- (id)moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx;


///-------------------------------
/// Stack operation
///-------------------------------

- (id)push:(id)object;

- (id)pop;


///-------------------------------
/// Queue operation
///-------------------------------

- (id)enqueue:(id)object;

- (id)dequeue;

@end
