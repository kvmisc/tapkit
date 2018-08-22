//
//  TKCommon.m
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCommon.h"
#import "TKMacro.h"

#pragma mark - System message

void TKPresentSystemMessage(NSString *message)
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];

  UIViewController *top = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  while ( top.presentedViewController ) { top = top.presentedViewController; }

  [top presentViewController:alertController animated:YES completion:NULL];
}



#pragma mark - Archive object

BOOL TKSaveArchivableObject(id object, NSString *path)
{
  if ( TK_S_NONEMPTY(path) ) {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [data writeToFile:path atomically:YES];
  }
  return NO;
}

id TKLoadArchivableObject(NSString *path)
{
  if ( TK_S_NONEMPTY(path) ) {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  }
  return nil;
}



#pragma mark - System paths

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
  return [[bundle?:[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForDocumentResource(NSString *relativePath)
{
  static NSString *DocumentPath = nil;
  if ( TK_S_EMPTY(DocumentPath) ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentPath = [pathAry objectAtIndex:0];
  }
  return [DocumentPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForLibraryResource(NSString *relativePath)
{
  static NSString *LibraryPath = nil;
  if ( TK_S_EMPTY(LibraryPath) ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    LibraryPath = [pathAry objectAtIndex:0];
  }
  return [LibraryPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForCachesResource(NSString *relativePath)
{
  static NSString *CachesPath = nil;
  if ( TK_S_EMPTY(CachesPath) ) {
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    CachesPath = [pathAry objectAtIndex:0];
  }
  return [CachesPath stringByAppendingPathComponent:relativePath];
}


BOOL TKCreateDirectory(NSString *path)
{
  if ( TK_S_NONEMPTY(path) ) {
    BOOL isDirectory = NO;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] ) {
      return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:NULL];
    }
    return isDirectory;
  }
  return NO;
}

BOOL TKDeleteFileOrDirectory(NSString *path)
{
  if ( TK_S_NONEMPTY(path) ) {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
  }
  return NO;
}



#pragma mark - Weak collections

NSMutableArray *TKCreateWeakMutableArray(void)
{
  return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
}

NSMutableDictionary *TKCreateWeakMutableDictionary(void)
{
  return (__bridge_transfer NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, nil, nil);
}

NSMutableSet *TKCreateWeakMutableSet(void)
{
  return (__bridge_transfer NSMutableSet *)CFSetCreateMutable(nil, 0, nil);
}
