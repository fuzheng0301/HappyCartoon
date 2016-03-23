//
//  ContentViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ChapterList.h"
#import "PlaceHolderLabel.h"
@interface ContentViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>;

@property (strong, nonatomic) IBOutlet UIScrollView *cartoonScrollView;

@property (strong, nonatomic) NSString * urlString;
@property (strong, nonatomic) NSString * NCTitle;
@property (copy, nonatomic)ChapterList*(^lastChapter)(void);
@property (copy, nonatomic)ChapterList*(^nextChapter)(void);
@property (strong, nonatomic) IBOutlet UISlider *lightSlider;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) PlaceHolderLabel * placeHolderLabel;

@end
