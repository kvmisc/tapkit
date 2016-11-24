//
//  TKMemoryCache.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKMemoryCache.h"
#import "TKMacro.h"

@implementation TKMemoryCache {
  NSMutableArray *_itemAry;
  NSLock *_lock;

  NSUInteger _operationTimes;
}

#pragma mark - Initiation

- (id)init
{
  self = [super init];
  if ( self ) {
    _itemAry = [[NSMutableArray alloc] init];
    _lock = [[NSLock alloc] init];

    _operationTimes = 0;
  }
  return self;
}


static TKMemoryCache *MemoryCache = nil;

+ (TKMemoryCache *)sharedObject
{
  return MemoryCache;
}

+ (void)saveObject:(TKMemoryCache *)object
{
  MemoryCache = object;
}



#pragma mark - Accessing caches

- (id)objectForKey:(NSString *)key;
{
  id object = nil;

  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    [self willOperate];

    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( (item) && (![item expired]) ) {
      object = item.object;
    }
    [_lock unlock];
  }
  return object;
}

- (BOOL)setObject:(id)object forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout
{
  BOOL result = NO;

  if ( TK_S_NONEMPTY(key) && (timeout>0.0) ) {
    [_lock lock];
    [self willOperate];

    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( !item ) {
      item = [[TKMemoryCacheItem alloc] init];
      [_itemAry addObject:item];
    }

    item.key = key;
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    item.object = object;

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
      TKMemoryCacheItem *item = [_itemAry objectAtIndex:i];
      if ( TK_EQUAL(key, item.key) ) {
        [_itemAry removeObjectAtIndex:i];
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

    TKMemoryCacheItem *item = [self itemByKey:key];
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
  [_lock unlock];
}

- (void)cleanUp
{
  [_lock lock];
  [self doCleanUp];
  [_lock unlock];
}



#pragma mark - Private methods

- (TKMemoryCacheItem *)itemByKey:(NSString *)key
{
  for ( TKMemoryCacheItem *item in _itemAry ) {
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
    TKMemoryCacheItem *item = [_itemAry objectAtIndex:i];
    if ( [item expired] ) {
      [_itemAry removeObjectAtIndex:i];
    } else {
      ++i;
    }
  }
}

@end



@implementation TKMemoryCacheItem

#pragma mark - Validity

- (BOOL)expired
{
  return ( [_expiry earlierDate:[NSDate date]]==_expiry );
}

@end
