//
//  MMMiniActionSheet.h
//  Paopao8
//
//  Created by Michaelin on 2017/3/31.
//
//

#import <UIKit/UIKit.h>
#import "MMMiniActionSheetItem.h"
#import "MMMiniActionSheetTriangleView.h"

// the enum of action sheet open direction
typedef NS_ENUM(NSUInteger, MMMiniActionSheetDirection) {
    MMMiniActionSheetDirectionMoveUp = 1,
    MMMiniActionSheetDirectionMoveDown,
};

// the click action process block
typedef void (^MMMiniActionSheetBlock)(NSInteger selectedMenuIndex);

@interface MMMiniActionSheet : UIView
{
	MMMiniActionSheetBlock		_block;
}

@property (nonatomic, strong)	NSMutableArray		*items;         // buttons in action sheet
@property (nonatomic, strong) MMMiniActionSheetTriangleView *arrowView;    // the arrow view towards to startpoint

// show mini action sheet with titles, images, tags of each button, the size of button, the availability of each button, the start point, displaying direction, and click process block.
+ (MMMiniActionSheet *)showMiniActionSheetWithTitles:(NSArray *)titles
                                          withImages:(NSArray *)images
                                            withTags:(NSArray *)tags
                                        withItemSize:(CGSize)size
                                  withAvailabilities:(NSArray *)availabilities
                                        atStartPoint:(CGPoint)startPoint
                                       menuDirection:(MMMiniActionSheetDirection)direction
                                        onSelectMenu:(MMMiniActionSheetBlock)block;

// show mini action sheet with titles, images, tags of each button, the size of button, the availability of each button, the color of background and font, the start point, displaying direction, and click process block.
+ (MMMiniActionSheet *)showMiniActionSheetWithTitles:(NSArray *)titles
                                          withImages:(NSArray *)images
                                            withTags:(NSArray *)tags
                                        withItemSize:(CGSize)size
                                  withAvailabilities:(NSArray *)availabilities
                                 withBackgroundColor:(UIColor *)backgroundColor
                                       withFontColor:(UIColor *)fontColor
                                        atStartPoint:(CGPoint)startPoint
                                       menuDirection:(MMMiniActionSheetDirection)direction
                                        onSelectMenu:(MMMiniActionSheetBlock)block;

// init mini action sheet with titles, images, tags of each button, the size of button, the availability of each button, the start point, and displaying direction.
- (MMMiniActionSheet *)initWithTitles:(NSArray *)titles
                           withImages:(NSArray *)images
                             withTags:(NSArray *)tags
                         withItemSize:(CGSize)size
                   withAvailabilities:(NSArray *)availabilities
                         atStartPoint:(CGPoint)startPoint
                        menuDirection:(MMMiniActionSheetDirection)direction;


// show method to show the mini action sheet
- (void)show:(MMMiniActionSheetBlock)block;

// hide the mini action sheet
- (void)dismiss;

@end
