//
//  ContentsHeaderCell.h
//  Project_A
//
//  Created by 付正 on 15/6/1.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comic.h"
@protocol ContentsHeaderCellDelegate<NSObject>

-(void)touchDescription;

@end
@interface ContentsHeaderCell : UITableViewCell

@property (strong,nonatomic)Comic * comic;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *author_name;
@property (strong, nonatomic) IBOutlet UILabel *theme_ids;
@property (strong, nonatomic) IBOutlet UILabel *image_all;
@property (strong, nonatomic) IBOutlet UILabel *click_total;
@property (strong, nonatomic) IBOutlet UILabel *contentDescription;

@property (weak, nonatomic)id<ContentsHeaderCellDelegate>delegate;


@end
