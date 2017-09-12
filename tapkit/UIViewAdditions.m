//
//  UIViewAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIViewAdditions.h"
#import "TKMacro.h"

UIView *TKFindFirstResponderInView(UIView *topView)
{
  if ( [topView isFirstResponder] ) {
    return topView;
  }
  for ( UIView *subview in topView.subviews ) {
    if ( [subview isFirstResponder] ) {
      return subview;
    }
    UIView *responder = TKFindFirstResponderInView(subview);
    if ( responder ) {
      return responder;
    }
  }
  return nil;
}

@implementation UIView (TapKit)

#pragma mark - Metric properties

- (CGFloat)leftX
{
  return self.frame.origin.x;
}
- (void)setLeftX:(CGFloat)leftX
{
  self.frame = CGRectMake(leftX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)centerX
{
  return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)rightX
{
  return self.frame.origin.x + self.frame.size.width;
}
- (void)setRightX:(CGFloat)rightX
{
  self.frame = CGRectMake(rightX-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}


- (CGFloat)topY
{
  return self.frame.origin.y;
}
- (void)setTopY:(CGFloat)topY
{
  self.frame = CGRectMake(self.frame.origin.x, topY, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)centerY
{
  return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)bottomY
{
  return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottomY:(CGFloat)bottomY
{
  self.frame = CGRectMake(self.frame.origin.x, bottomY-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}


- (CGFloat)width
{
  return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)height
{
  return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}


- (CGPoint)origin
{
  return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
  self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size
{
  return self.frame.size;
}
- (void)setSize:(CGSize)size
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}



#pragma mark - Nib file

+ (id)loadFromNib
{
  return [self loadFromNibNamed:NSStringFromClass(self)];
}

+ (id)loadFromNibNamed:(NSString *)name
{
  if ( TK_S_NONEMPTY(name) ) {
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject];
  }
  return nil;
}



#pragma mark - Image content

- (UIImage *)imageRep
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}



#pragma mark - Finding

- (UIView *)descendantOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  }
  for ( UIView *subview in self.subviews ) {
    UIView *view = [subview descendantOrSelfWithClass:cls];
    if ( view ) {
      return view;
    }
  }
  return nil;
}

- (UIView *)ancestorOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  } else if ( self.superview ) {
    return [self.superview ancestorOrSelfWithClass:cls];
  }
  return nil;
}


- (UIView *)findFirstResponder
{
  return TKFindFirstResponderInView(self);
}



#pragma mark - Hierarchy

- (void)bringToFront
{
  [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
  [self.superview sendSubviewToBack:self];
}

- (BOOL)isInFront
{
  NSArray *subviewAry = self.superview.subviews;
  return ( [subviewAry lastObject]==self );
}

- (BOOL)isAtBack
{
  NSArray *subviewAry = self.superview.subviews;
  return ( [subviewAry firstObject]==self );
}

@end
