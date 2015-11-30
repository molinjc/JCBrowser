//
//  UIView+Coordinate.m
//  JCChat_XMPP
//
//  Created by molin on 15/11/26.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "UIView+Coordinate.h"

@implementation UIView (Coordinate)

                   // @dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;

#pragma mark - Setters

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    self.width = size.width;
    self.height = size.height;
}

- (void)setOrigin:(CGPoint)origin {
    self.x = origin.x;
    self.y = origin.y;
}

#pragma mark - Getters

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return CGSizeMake(self.width, self.height);
}

- (CGPoint)origin {
    return CGPointMake(self.x, self.y);;
}

@end
