//
//  RankTableViewCell.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "RankTableViewCell.h"

@implementation RankTableViewCell

-(void)setRankModel:(RankModel *)rankModel
{
    _rankModel = rankModel;
    
    //使用SDWebImage方法下载图片
    NSURL *url = [NSURL URLWithString:rankModel.cover];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"backImage"]];
    
    self.headTitle.text = rankModel.rankingName;
    self.introduce1.text = rankModel.rankingDescription1;
    self.introduce2.text = rankModel.rankingDescription2;
}


@end
