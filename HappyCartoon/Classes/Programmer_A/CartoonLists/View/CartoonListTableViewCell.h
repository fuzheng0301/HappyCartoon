//
//  CartoonListTableViewCell.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonListsDetail.h"
@interface CartoonListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *click_totals;
@property (strong, nonatomic) IBOutlet UILabel *cartoonTag;
@property (strong, nonatomic) IBOutlet UILabel *lastChapter;

@property (strong, nonatomic) CartoonListsDetail * detail;


@end
