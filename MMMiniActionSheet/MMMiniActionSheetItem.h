//
//  MMMiniActionSheetItem.h
//  Paopao8
//
//  Created by Michaelin on 2017/3/31.
//
//

#import <UIKit/UIKit.h>

@interface MMMiniActionSheetItem : UIView

// init a action sheet item with frame, title, displaying icon, and the position of it.
// the position of top item is -1, middle one is 0, and bottom one is 1;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image position:(int)position;

@property (nonatomic)				BOOL			highlight;          // the item is high light or not
@property (nonatomic, readonly)		UILabel			*actionSheetTitleLabel;   // the label to display the title of item
@property (nonatomic, readonly) 	UIImageView		*actionSheetImageView;    // the image view to show the icon

@end

CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt);
