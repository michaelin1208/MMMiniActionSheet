//
//  MMMiniActionSheet.m
//  Paopao8
//
//  Created by Michaelin on 2017/3/31.
//
//

#import "MMMiniActionSheet.h"
#define kArrowWidth 14
#define kArrowHeight 7

@interface MMMiniActionSheet ()
{
	
	NSMutableArray *_items;         // The clickable buttons in action sheet
	MMMiniActionSheetDirection _menuDirection;     // The animation direction of action sheet
	CGPoint _startPoint;        // The start point of action sheet
}

@end

@implementation MMMiniActionSheet

static UIWindow *_overlayWindow;    // The cover window

// Set the selected item
- (void)clearHighlightWithExcept:(MMMiniActionSheetItem *)selectedItem
{
	for(MMMiniActionSheetItem *item in _items)
		item.highlight = (item == selectedItem);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	NSArray			*touchs = [allTouches allObjects];
	UITouch			*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		[self clearHighlightWithExcept:nil];
		MMMiniActionSheetItem	*actionSheetItem = nil;
		for(MMMiniActionSheetItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				actionSheetItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(actionSheetItem)
			actionSheetItem.highlight = YES;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	NSArray			*touchs = [allTouches allObjects];
	UITouch			*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		MMMiniActionSheetItem	*actionSheetItem = nil;
		for(MMMiniActionSheetItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				actionSheetItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(actionSheetItem)
		{
			[self clearHighlightWithExcept:actionSheetItem];
			[self dismissWithSelect:actionSheetItem];
		}
		else
		{
			[self clearHighlightWithExcept:nil];
			[self dismiss];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet				*allTouches = [event allTouches];
	NSArray				*touchs = [allTouches allObjects];
	UITouch				*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		MMMiniActionSheetItem	*actionSheetItem = nil;
		for(MMMiniActionSheetItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				actionSheetItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(!actionSheetItem)
			[self clearHighlightWithExcept:nil];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self clearHighlightWithExcept:nil];
}

- (void)show:(MMMiniActionSheetBlock)block
{
	_block = block;
	
	for(int i = 0; i < [_items count]; i++)
	{
		MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:i];
		actionSheetItem.hidden = NO;
	}
	
    [UIView animateWithDuration:0.2 animations:^{
		for(int i = 0; i < [_items count]; i++)
		{
			MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:i];
			CGRect r = actionSheetItem.frame;
			if(_menuDirection == MMMiniActionSheetDirectionMoveUp)
			{
				r.origin.y += i * r.size.height * -1;
			}
			else if(_menuDirection == MMMiniActionSheetDirectionMoveDown)
			{
				r.origin.y += i * r.size.height * 1;
			}
			actionSheetItem.frame = r;
		}
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWithSelect:(MMMiniActionSheetItem *)selectedItem
{
    NSInteger tag = selectedItem.tag;
    
	int selectedIndex = (int)[_items indexOfObject:selectedItem];
	selectedItem.highlight = YES;
	
    [UIView animateWithDuration:0.1 animations:^{
		CGRect r;
		for(int i = 0; i < [_items count]; i++)
		{
			MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:i];
			if(i == 0)
				r = actionSheetItem.frame;
			if(selectedItem != actionSheetItem)
			{
				CGPoint point = [self centerPointForRotation:actionSheetItem];
				actionSheetItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
				actionSheetItem.frame = r;
				actionSheetItem.alpha = 0.2;
			}
		}
        self.arrowView.alpha = 0.2;
    } completion:^(BOOL finished) {
		for(int i = 0; i < [_items count]; i++)
		{
			MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:i];
			if(selectedItem != actionSheetItem)
				actionSheetItem.hidden = YES;
		}
		[UIView animateWithDuration:0.2 animations:^{
			MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:selectedIndex];
			CGRect r = ((UIView *)[_items objectAtIndex:0]).frame;
			if(selectedItem == actionSheetItem)
			{
				CGPoint point = [self centerPointForRotation:actionSheetItem];
				actionSheetItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
				actionSheetItem.frame = r;
				actionSheetItem.alpha = 0.5;
			}
		} completion:^(BOOL finished) {
			if(_block)
				_block(tag);
			[self releaseMenu];
		}];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
		CGRect r;
		for(int i = 0; i < [_items count]; i++)
		{
			MMMiniActionSheetItem *actionSheetItem = [_items objectAtIndex:i];
			if(i == 0)
				r = actionSheetItem.frame;
			CGPoint point = [self centerPointForRotation:actionSheetItem];
			actionSheetItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
			actionSheetItem.frame = r;
			actionSheetItem.alpha = 0.2;
		}
        self.arrowView.alpha = 0.2;
    } completion:^(BOOL finished) {
		[self releaseMenu];
    }];
}

- (void)releaseMenu
{
	_block = nil;
    _overlayWindow.hidden = YES;
    //_overlayWindow = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
	
	
}


+ (MMMiniActionSheet *)showMiniActionSheetWithTitles:(NSArray *)titles
                                          withImages:(NSArray *)images
                                            withTags:(NSArray *)tags
                                        withItemSize:(CGSize)size
                                  withAvailabilities:(NSArray *)availabilities
                                        atStartPoint:(CGPoint)startPoint
                                       menuDirection:(MMMiniActionSheetDirection)direction
                                        onSelectMenu:(MMMiniActionSheetBlock)block
{
//    NSLog(@"startPoint %f %f",startPoint.x, startPoint.y);
    MMMiniActionSheet *miniActionSheet = [[MMMiniActionSheet alloc] initWithTitles:titles withImages:images withTags:tags withItemSize:size withAvailabilities:availabilities atStartPoint:startPoint menuDirection:direction];
	[miniActionSheet show:block];
	return miniActionSheet;
}

+ (MMMiniActionSheet *)showMiniActionSheetWithTitles:(NSArray *)titles
                                          withImages:(NSArray *)images
                                            withTags:(NSArray *)tags
                                        withItemSize:(CGSize)size
                                  withAvailabilities:(NSArray *)availabilities
                                 withBackgroundColor:(UIColor *)backgroundColor
                                       withFontColor:(UIColor *)fontColor
                                        atStartPoint:(CGPoint)startPoint
                                       menuDirection:(MMMiniActionSheetDirection)direction
                                        onSelectMenu:(MMMiniActionSheetBlock)block
{
    //    NSLog(@"startPoint %f %f",startPoint.x, startPoint.y);
    MMMiniActionSheet *miniActionSheet = [[MMMiniActionSheet alloc] initWithTitles:titles withImages:images withTags:tags withItemSize:size withAvailabilities:availabilities atStartPoint:startPoint menuDirection:direction];
    
    [miniActionSheet setColorOfItems:backgroundColor];
    [miniActionSheet setColorOfFont:fontColor];
    
    [miniActionSheet show:block];
    return miniActionSheet;
}

- (MMMiniActionSheet *)initWithTitles:(NSArray *)titles
                           withImages:(NSArray *)images
                             withTags:(NSArray *)tags
                         withItemSize:(CGSize)size
                   withAvailabilities:(NSArray *)availabilities
                         atStartPoint:(CGPoint)startPoint
                        menuDirection:(MMMiniActionSheetDirection)direction
{
	CGRect rect = [UIScreen mainScreen].bounds;
	self = [self initWithFrame:rect];
	_menuDirection = direction;
	
    int max = (int)MAX([titles count], [images count]);
    
    CGRect r = direction == MMMiniActionSheetDirectionMoveUp ? CGRectMake(startPoint.x-size.width/2, startPoint.y-size.height-27, size.width, size.height):CGRectMake(startPoint.x-size.width/2, startPoint.y-13, size.width, size.height);
    
    if (CGRectGetMinX(r)<0) {
        r.origin.x = 0;
    }else if (CGRectGetMaxX(r)>self.superview.frame.size.width){
        r.origin.x = self.superview.frame.size.width - r.size.width;
    }
    
	for(int i = 0; i < max; i++)
	{
        NSLog(@"x %f y %f width %f height %f", r.origin.x, r.origin.y, r.size.width, r.size.height);
        
		NSString *title = (i < [titles count]) ? [titles objectAtIndex:i] : @"";
		UIImage *image = (i < [images count]) ? [images objectAtIndex:i] : nil;
        NSNumber * tag = (i < [tags count]) ? [tags objectAtIndex:i] : @0;
        int position = 0;
        if (i == 0) {
            position = direction == MMMiniActionSheetDirectionMoveUp ? 1 : -1;
        }else if (i == max - 1) {
            position = direction == MMMiniActionSheetDirectionMoveUp ? -1 : 1;
        }
		MMMiniActionSheetItem *actionSheetItem = [[MMMiniActionSheetItem alloc] initWithFrame:r withTitle:title withImage:image position:position];
        
        actionSheetItem.tag = tag.integerValue;
        
		if(direction == MMMiniActionSheetDirectionMoveUp)
			actionSheetItem.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        else if(direction == MMMiniActionSheetDirectionMoveDown)
			actionSheetItem.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        if (availabilities != nil && availabilities.count > i && ![availabilities[i] boolValue]) {
            actionSheetItem.alpha = 0.2;
        }else{
            actionSheetItem.alpha = 1;
        }
		
		actionSheetItem.hidden = YES;
		[self addSubview:actionSheetItem];
		[_items addObject:actionSheetItem];
    }

    self.arrowView = [[MMMiniActionSheetTriangleView alloc] initWithFrame:direction == MMMiniActionSheetDirectionMoveUp ? CGRectMake(startPoint.x-kArrowWidth/2, r.origin.y + r.size.height, kArrowWidth, kArrowHeight) : CGRectMake(startPoint.x-kArrowWidth/2, r.origin.y - kArrowHeight, kArrowWidth, kArrowHeight)];
    if (direction == MMMiniActionSheetDirectionMoveDown) {
        CGAffineTransform at = CGAffineTransformMakeRotation(M_PI);
        [self.arrowView setTransform:at];
    }
    [self addSubview:self.arrowView];
		
	return self;
}

- (void)setColorOfItems:(UIColor *)color {
    for (UIView *view in _items) {
        view.backgroundColor = color;
    }
    self.arrowView.fillColor = color;
}

- (void)setColorOfFont:(UIColor *)color {
    for (MMMiniActionSheetItem *view in _items) {
        view.actionSheetTitleLabel.textColor = color;
    }
}

- (CGPoint)centerPointForRotation:(MMMiniActionSheetItem *)item
{
	CGFloat x = _menuDirection == MMMiniActionSheetDirectionMoveUp ? self.frame.size.width : -self.frame.size.width;
	CGFloat y = _menuDirection == MMMiniActionSheetDirectionMoveDown ? -item.frame.origin.y : self.frame.size.height - item.frame.origin.y;
	return CGPointMake(x, y);
}


- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = UIInterfaceOrientationAngleOfOrientation(statusBarOrientation);
    CGFloat statusBarHeight = [[self class] getStatusBarHeight];
	
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
	
    [self setIfNotEqualTransform:transform frame:frame];
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    if(!CGAffineTransformEqualToTransform(self.transform, transform))
    {
        self.transform = transform;
    }
    if(!CGRectEqualToRect(self.frame, frame))
    {
        self.frame = frame;
    }
}

+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{
    CGRect frame = windowBounds;
    frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
    frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
    frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
    frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    return frame;
}

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle;
	
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
	
    return angle;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation)
{
    return 1 << orientation;
}

- (void)createOverlayWindow
{
    
	CGRect rect = [UIScreen mainScreen].bounds;
    if (!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:rect];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_overlayWindow makeKeyAndVisible];
        
    }else{
        _overlayWindow.hidden = NO;
    }
	
	[_overlayWindow addSubview:self];
	
	[self statusBarFrameOrOrientationChanged:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		_items = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor clearColor];
		[self createOverlayWindow];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_items = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor clearColor];
		[self createOverlayWindow];
    }
    return self;
}

@end
