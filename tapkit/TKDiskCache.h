//
//  TKDiskCache.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKDiskCache : NSObject

///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithPath:(NSString *)path;


+ (TKDiskCache *)sharedObject;

+ (void)saveObject:(TKDiskCache *)object;


///-------------------------------
/// Accessing caches
///-------------------------------

- (NSData *)dataForKey:(NSString *)key;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout;

- (void)removeCacheForKey:(NSString *)key;


- (BOOL)hasCacheForKey:(NSString *)key;


///-------------------------------
/// Reorganize cache
///-------------------------------

- (void)clearAll;

- (void)cleanUp;


///-------------------------------
/// Disk operation
///-------------------------------

- (void)synchronize;

- (NSString *)pathForKey:(NSString *)key;

@end



@interface TKDiskCacheItem : NSObject<NSCoding>

///-------------------------------
/// Properties
///-------------------------------

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *expiry;
@property (nonatomic, assign) NSUInteger size;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)expired;

@end
