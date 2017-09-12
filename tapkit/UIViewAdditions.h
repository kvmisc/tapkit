//
//  UIViewAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (TapKit)

///-------------------------------
/// Metric properties
///-------------------------------

@property (nonatomic, assign) CGFloat leftX;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat rightX;

@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat bottomY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;


///-------------------------------
/// Nib file
///-------------------------------

+ (id)loadFromNib;

+ (id)loadFromNibNamed:(NSString *)name;


///-------------------------------
/// Image content
///-------------------------------

- (UIImage *)imageRep;


///-------------------------------
/// Finding
///-------------------------------

- (UIView *)descendantOrSelfWithClass:(Class)cls;

- (UIView *)ancestorOrSelfWithClass:(Class)cls;


- (UIView *)findFirstResponder;


///-------------------------------
/// Hierarchy
///-------------------------------

- (void)bringToFront;

- (void)sendToBack;

- (BOOL)isInFront;

- (BOOL)isAtBack;

@end
