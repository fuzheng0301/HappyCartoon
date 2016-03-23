//
//  RankTableViewCell.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
#import "UIImageView+WebCache.h"
@interface RankTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (strong, nonatomic) IBOutlet UILabel *headTitle;//标题
@property (strong, nonatomic) IBOutlet UILabel *introduce1;//简介1
@property (strong, nonatomic) IBOutlet UILabel *introduce2;//简介2

@property(nonatomic,strong)RankModel *rankModel;


@end
