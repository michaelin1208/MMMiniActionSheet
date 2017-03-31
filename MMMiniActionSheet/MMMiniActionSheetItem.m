//
//  MMMiniActionSheetItem.m
//  Paopao8
//
//  Created by Michaelin on 2017/3/31.
//
//

#import "MMMiniActionSheetItem.h"

#define kMiniActionSheetItemGap 10

@interface MMMiniActionSheetItem ()
{
	UIView *_highlightView;
}

@end


@implementation MMMiniActionSheetItem


- (BOOL)highlight
{
	return (_highlightView != nil);
}

- (void)setHighlight:(BOOL)highlight
{
	if(!highlight && _highlightView == nil)
		return;
	if(highlight && _highlightView != nil)
		return;
	
	if(highlight)
	{
		_highlightView = [[UIView alloc] initWithFrame:self.bounds];
		_highlightView.layer.cornerRadius = 10;
		_highlightView.layer.masksToBounds = YES;
		_highlightView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.2];
		[super addSubview:_highlightView];
	}
	else
	{
		[_highlightView removeFromSuperview];
		_highlightView = nil;
	}
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image position:(int)position
{
//    frame.origin.x = frame.origin.x - 80;
    self = [self initWithFrame:frame];
    if (self)
    {
        _actionSheetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMiniActionSheetItemGap, kMiniActionSheetItemGap, CGRectGetHeight(frame) - kMiniActionSheetItemGap * 2, CGRectGetHeight(frame) - kMiniActionSheetItemGap * 2)];
        _actionSheetImageView.contentMode = UIViewContentModeScaleAspectFit;
        _actionSheetImageView.image = image;
        [self addSubview:_actionSheetImageView];
        
        _actionSheetTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_actionSheetImageView.frame) + kMiniActionSheetItemGap, CGRectGetMinY(_actionSheetImageView.frame), frame.size.width - CGRectGetMaxX(_actionSheetImageView.frame) - kMiniActionSheetItemGap * 2, CGRectGetHeight(_actionSheetImageView.frame))];
        _actionSheetTitleLabel.textAlignment = NSTextAlignmentCenter;
        _actionSheetTitleLabel.font = [UIFont boldSystemFontOfSize:CGRectGetHeight(_actionSheetImageView.frame)*0.8];
        _actionSheetTitleLabel.backgroundColor = [UIColor clearColor];
        _actionSheetTitleLabel.textColor = [UIColor whiteColor];
        _actionSheetTitleLabel.text = title;
        [self addSubview:_actionSheetTitleLabel];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        if (position == -1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame         = self.bounds;
            maskLayer.path          = maskPath.CGPath;
            self.layer.mask         = maskLayer;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-1, self.frame.size.width - 20, 1)];
            line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
            [self addSubview:line];
        }else if (position == 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-1, self.frame.size.width - 20, 1)];
            line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
            [self addSubview:line];
        }else{
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame         = self.bounds;
            maskLayer.path          = maskPath.CGPath;
            self.layer.mask         = maskLayer;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt)
{
    const CGFloat fx = pt.x;
    const CGFloat fy = pt.y;
    const CGFloat fcos = cos(angle);
    const CGFloat fsin = sin(angle);
    return CGAffineTransformMake(fcos, fsin, -fsin, fcos, fx - fx * fcos + fy * fsin, fy - fx * fsin - fy * fcos);
}

@end
