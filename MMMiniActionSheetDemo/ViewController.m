//
//  ViewController.m 
//  MMMiniActionSheetDemo
//
//  Created by Michaelin on 2017/3/31.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickMeBtnClicked:(id)sender {
       NSArray *btnArray = [NSArray arrayWithObjects:@"A0",@"NA1",@"A2",@"A3",@"NA4",nil];
       NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"camera_change"],[UIImage imageNamed:@"camera_flash"],[UIImage imageNamed:@"camera_change"],[UIImage imageNamed:@"camera_flash"],[UIImage imageNamed:@"camera_change"],nil];
      NSArray *tagArray = [NSArray arrayWithObjects:@0,@1,@2,@3,@4,nil];
    NSArray *availabilities = [NSArray arrayWithObjects: @1, @0, @1, @1, @0, nil];
    [MMMiniActionSheet showMiniActionSheetWithTitles:btnArray
                                          withImages:imageArray
                                            withTags:tagArray
                                        withItemSize:CGSizeMake(100, 36)
                                  withAvailabilities:availabilities
                                        atStartPoint:CGPointMake(CGRectGetMidX(self.clickMeBtn.frame), CGRectGetMidY(self.clickMeBtn.frame))
                                       menuDirection:MMMiniActionSheetDirectionMoveUp
                                        onSelectMenu:^(NSInteger selectedMenuIndex) {
                                            NSLog(@"menu index : %d", (int)selectedMenuIndex);
                                        }];
}
@end
