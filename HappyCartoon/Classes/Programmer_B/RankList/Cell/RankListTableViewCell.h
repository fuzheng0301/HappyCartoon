//
//  RankListTableViewCell.h
//  Project_A
//
//  Created by 付正 on 15/5/30.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankListModel.h"
#import "UIImageView+WebCache.h"
@interface RankListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (strong, nonatomic) IBOutlet UILabel *rankListTitle;//标题
@property (strong, nonatomic) IBOutlet UILabel *writerLabel;//作者
@property (strong, nonatomic) IBOutlet UILabel *voteLabel;//投票数
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;//类型
@property (strong, nonatomic) IBOutlet UILabel *monthVoteLabel;//月票票数

@property (strong, nonatomic) RankListModel *rankListModel;


@end
