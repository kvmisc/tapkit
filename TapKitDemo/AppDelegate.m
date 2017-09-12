//
//  AppDelegate.m
//  TapKitDemo
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "AppDelegate.h"
#import "TKViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.backgroundColor = [UIColor whiteColor];
  
  _window.rootViewController = [[TKViewController alloc] init];


  NSString *url = @"http://www.abc.com/login.do?aa=a s d f&bb=1+2";

  NSCharacterSet *allowedSet = [[NSCharacterSet characterSetWithCharactersInString:@":/?&=;+!@#$()',*"] invertedSet];
  NSString *string = [url stringByAddingPercentEncodingWithAllowedCharacters:allowedSet];
  NSLog(@"%@", string);
  NSLog(@"%@", [string stringByRemovingPercentEncoding]);

  [_window makeKeyAndVisible];
  return YES;
}

@end
