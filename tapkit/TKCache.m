//
//  TKCache.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCache.h"
#import "TKMacro.h"
#import "TKCommon.h"

#define CACHE_SETTING @"ad68bddb-7e05-40e3-afb5-d79806d831d0"


@implementation TKCache {
  NSString *_path;

  NSMutableArray *_itemAry;
  NSLock *_lock;
}

#pragma mark - Initiation

- (id)init
{
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithPath:(NSString *)path
{
  self = [super init];
  if ( self ) {
    _path = [path copy];
    [self initialize];
  }
  return self;
}

- (void)initialize
{
  _itemAry = [[NSMutableArray alloc] init];
  _lock = [[NSLock alloc] init];

  if ( TK_S_NONEMPTY(_path) ) {
    TKCreateDirectory(_path);

    NSString *path = [self pathForKey:CACHE_SETTING];
    NSArray *itemAry = TKLoadArchivableObject(path);
    for ( TKCacheItem *item in itemAry ) {
      if ( [item expired] ) {
        TKDeleteFileOrDirectory([self pathForKey:item.key]);
      } else {
        [_itemAry addObject:item];
      }
    }
    TKSaveArchivableObject(_itemAry, path);
  }
}


static TKCache *Cache = nil;

+ (TKCache *)sharedObject
{
  return Cache;
}

+ (void)saveObject:(TKCache *)object
{
  Cache = object;
}



#pragma mark - Accessing caches

- (id)objectForKey:(NSString *)key
{
  id object = nil;
  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    TKCacheItem *item = [self itemByKey:key];
    if ( (item) && (![item expired]) ) {
      if ( TK_S_NONEMPTY(_path) ) {
        object = [[NSData alloc] initWithContentsOfFile:[self pathForKey:item.key]];
      } else {
        object = item.object;
      }
    }
    [_lock unlock];
  }
  [self delayCleanUp];
  return object;
}

- (void)setObject:(id)object forKey:(NSString *)key withTimeout:(NSTimeInterval)timeout
{
  if ( TK_S_NONEMPTY(key) && (timeout>0.0) ) {
    [_lock lock];

    TKCacheItem *item = [self itemByKey:key];
    if ( !item ) {
      item = [[TKCacheItem alloc] init];
      [_itemAry addObject:item];
    }

    item.key = key;
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
    if ( TK_S_NONEMPTY(_path) ) {
      item.size = [object length];
      NSString *path = [self pathForKey:key];
      if ( object ) {
        [object writeToFile:path atomically:YES];
      } else {
        TKDeleteFileOrDirectory(path);
      }
    } else {
      item.object = object;
    }

    [_lock unlock];
  }
  [self delayCleanUp];
}

- (void)removeCacheForKey:(NSString *)key
{
  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    for ( NSUInteger i=0; i<[_itemAry count]; ++i ) {
      TKCacheItem *item = [_itemAry objectAtIndex:i];
      if ( TK_EQUAL(key, item.key) ) {
        TKDeleteFileOrDirectory([self pathForKey:item.key]);
        [_itemAry removeObjectAtIndex:i];
        break;
      }
    }
    [_lock unlock];
  }
  [self delayCleanUp];
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;
  if ( TK_S_NONEMPTY(key) ) {
    [_lock lock];
    TKCacheItem *item = [self itemByKey:key];
    result = ( (item) && (![item expired]) );
    [_lock unlock];
  }
  [self delayCleanUp];
  return result;
}



#pragma mark - Reorganize cache

- (void)clearAll
{
  [_lock lock];
  if ( TK_S_NONEMPTY(_path) ) {
    TKDeleteFileOrDirectory(_path);
    TKCreateDirectory(_path);
  }
  [_itemAry removeAllObjects];
  TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
  [_lock unlock];
}

- (void)cleanUp
{
  [self doCleanUp:nil];
}



#pragma mark - Disk operation

- (void)synchronize
{
  if ( TK_S_NONEMPTY(_path) ) {
    [_lock lock];
    TKSaveArchivableObject(_itemAry, [self pathForKey:CACHE_SETTING]);
    [_lock unlock];
  }
}

- (NSString *)pathForKey:(NSString *)key
{
  return [_path stringByAppendingPathComponent:key];
}



#pragma mark - Private methods

- (TKCacheItem *)itemByKey:(NSString *)key
{
  for ( TKCacheItem *item in _itemAry ) {
    if ( TK_EQUAL(key, item.key) ) {
      return item;
    }
  }
  return nil;
}

- (void)delayCleanUp
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doCleanUp:) object:nil];
  [self performSelector:@selector(doCleanUp:) withObject:nil afterDelay:1.0];
}

- (void)doCleanUp:(id)object
{
  [_lock lock];
  for ( NSUInteger i=0; i<[_itemAry count]; /**/ ) {
    TKCacheItem *item = [_itemAry objectAtIndex:i];
    if ( [item expired] ) {
      TKDeleteFileOrDirectory([self pathForKey:item.key]);
      [_itemAry removeObjectAtIndex:i];
    } else {
      ++i;
    }
  }
  [_lock unlock];
}

@end



@implementation TKCacheItem

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _key = [decoder decodeObjectForKey:@"kKey"];
    _expiry = [decoder decodeObjectForKey:@"kExpiry"];

    _size = [decoder decodeIntegerForKey:@"kSize"];

    //_object = [decoder decodeObjectForKey:@"kObject"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_key forKey:@"kKey"];
  [encoder encodeObject:_expiry forKey:@"kExpiry"];

  [encoder encodeInteger:_size forKey:@"kSize"];

  //[encoder encodeObject:_object forKey:@"kObject"];
}



#pragma mark - Validity

- (BOOL)expired
{
  return ( [_expiry earlierDate:[NSDate date]]==_expiry );
}

@end
