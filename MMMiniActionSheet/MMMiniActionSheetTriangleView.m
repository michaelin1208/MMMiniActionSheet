//
//  MMMiniActionSheetTriangleView.m
//  Paopao8
//
//  Created by Michaelin on 2017/3/31.
//
//

#import "MMMiniActionSheetTriangleView.h"

@interface MMMiniActionSheetTriangleView ()
{
}

@end

@implementation MMMiniActionSheetTriangleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 0);
    CGContextClosePath(context);
    
    [_fillColor setFill];
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
