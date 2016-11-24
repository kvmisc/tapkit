//
//  TKMemoryCache.h
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMemoryCache : NSObject

///-------------------------------
/// Initiation
///-------------------------------

+ (TKMemoryCache *)sharedObject;

+ (void)saveObject:(TKMemoryCache *)object;


///-------------------------------
/// Accessing caches
///-------------------------------

- (id)objectForKey:(NSString *)key;

- (BOOL)setObject:(id)object forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout;

- (void)removeCacheForKey:(NSString *)key;


- (BOOL)hasCacheForKey:(NSString *)key;


///-------------------------------
/// Reorganize cache
///-------------------------------

- (void)clearAll;

- (void)cleanUp;

@end



@interface TKMemoryCacheItem : NSObject

///-------------------------------
/// Properties
///-------------------------------

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *expiry;
@property (nonatomic, strong) id object;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)expired;

@end
