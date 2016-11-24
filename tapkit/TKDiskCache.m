//
//  TKDiskCache.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKDiskCache.h"
#import "TKMacro.h"
#import "TKCommon.h"

#define CACHE_SETTING @"ad68bddb-7e05-40e3-afb5-d79806d831d0"


@implementation TKDiskCache {
  NSString *_path;

  NSMutableArray *_itemAry;
  NSLock *_lock;

  NSUInteger _operationTimes;
}

#pragma mark - Initiation

- (id)initWithPath:(NSString *)path
{
  self = [super init];
  if ( self ) {
    if ( TK_S_NONEMPTY(path) ) {
      _path = [path copy];

      _itemAry = [[NSMutableArray alloc] init];
      _lock = [[NSLock alloc] init];

      _operationTimes = 0;


      TKCreateDirectory(_path);

      NSArray *itemAry = TKLoadArchivableObject([self pathForKey:CACHE_SETTING]);
      for ( TKDiskCacheItem *item in itemAry ) {
        if ( [item expired] ) {
          TKDeleteFileOrDirectory([self pathForKey:item.key]);
        } else {
          [_itemAry addObject:item];
        }
      }
      TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
    } else {
      return nil;
    }
  }
  return self;
}


static TKDiskCache *DiskCache = nil;

+ (TKDiskCache *)sharedObject
{
  return DiskCache;
}

+ (void)saveObject:(TKDiskCache *)object
{
  DiskCache = object;
}



#pragma mark - Accessing caches

- (NSData *)dataForKey:(NSString *)key
{
  NSData *data = nil;

  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    [self willOperate];

    TKDiskCacheItem *item = [self itemByKey:key];
    if ( (item) && (![item expired]) ) {
      data = [[NSData alloc] initWithContentsOfFile:[self pathForKey:item.key]];
    }
    [_lock unlock];
  }
  return data;
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout
{
  BOOL result = NO;

  if ( TK_S_NONEMPTY(key) && (timeout>0.0) ) {
    [_lock lock];
    [self willOperate];

    TKDiskCacheItem *item = [self itemByKey:key];
    if ( !item ) {
      item = [[TKDiskCacheItem alloc] init];
      [_itemAry addObject:item];
    }

    item.key = key;
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    item.size = [data length];

    NSString *path = [self pathForKey:key];
    if ( data ) {
      [data writeToFile:path atomically:YES];
    } else {
      TKDeleteFileOrDirectory(path);
    }

    result = YES;

    [_lock unlock];
  }
  return result;
}

- (void)removeCacheForKey:(NSString *)key
{
  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    [self willOperate];

    for ( NSUInteger i=0; i<[_itemAry count]; ++i ) {
      TKDiskCacheItem *item = [_itemAry objectAtIndex:i];
      if ( TK_EQUAL(key, item.key) ) {
        [_itemAry removeObjectAtIndex:i];
        TKDeleteFileOrDirectory([self pathForKey:item.key]);
        break;
      }
    }
    [_lock unlock];
  }
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;

  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    [self willOperate];

    TKDiskCacheItem *item = [self itemByKey:key];
    result = ( (item) && (![item expired]) );
    [_lock unlock];
  }
  return result;
}



#pragma mark - Reorganize cache

- (void)clearAll
{
  [_lock lock];
  [_itemAry removeAllObjects];
  TKDeleteFileOrDirectory(_path);
  TKCreateDirectory(_path);
  [_lock unlock];
}

- (void)cleanUp
{
  [_lock lock];
  [self doCleanUp];
  [_lock unlock];
}



#pragma mark - Disk operation

- (void)synchronize
{
  [_lock lock];
  TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
  [_lock unlock];
}

- (NSString *)pathForKey:(NSString *)key
{
  return [_path stringByAppendingPathComponent:key];
}



#pragma mark - Private methods

- (TKDiskCacheItem *)itemByKey:(NSString *)key
{
  for ( TKDiskCacheItem *item in _itemAry ) {
    if ( TK_EQUAL(key, item.key) ) {
      return item;
    }
  }
  return nil;
}

- (void)willOperate
{
  _operationTimes = _operationTimes+1;
  if ( _operationTimes>100 ) {
    _operationTimes = 0;
    [self doCleanUp];
  }
}

- (void)doCleanUp
{
  for ( NSUInteger i=0; i<[_itemAry count]; /**/ ) {
    TKDiskCacheItem *item = [_itemAry objectAtIndex:i];
    if ( [item expired] ) {
      [_itemAry removeObjectAtIndex:i];
      TKDeleteFileOrDirectory([self pathForKey:item.key]);
    } else {
      ++i;
    }
  }
}

@end



@implementation TKDiskCacheItem

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _key = [decoder decodeObjectForKey:@"kKey"];
    _expiry = [decoder decodeObjectForKey:@"kExpiry"];
    _size = [decoder decodeIntegerForKey:@"kSize"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_key forKey:@"kKey"];
  [encoder encodeObject:_expiry forKey:@"kExpiry"];
  [encoder encodeInteger:_size forKey:@"kSize"];
}



#pragma mark - Validity

- (BOOL)expired
{
  return ( [_expiry earlierDate:[NSDate date]]==_expiry );
}

@end
