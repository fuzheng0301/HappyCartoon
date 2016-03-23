//
//  RankListTableViewCell.m
//  Project_A
//
//  Created by 付正 on 15/5/30.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "RankListTableViewCell.h"

@implementation RankListTableViewCell

-(void)setRankListModel:(RankListModel *)rankListModel
{
    _rankListModel = rankListModel;
    
    
    self.rankListTitle.text = rankListModel.name;//标题
    //    NSLog(@"%@",cell.rankListTitle.text);
    self.writerLabel.text = rankListModel.nickname;//作者
    self.monthVoteLabel.text = rankListModel.extraValue;//月票
    self.voteLabel.text = rankListModel.click_total;//投票数
    
    //数组转成字符串
    NSString *string = nil;
    NSString *lastString = @"";
    for (NSString *value in rankListModel.tags) {
        string = [NSString stringWithFormat:@"%@ %@", lastString, value];
        //        NSLog(@"value:%@", value);
        //        NSLog(@"string:%@",string);
        lastString = [NSString stringWithFormat:@"%@", string];
    }
    self.categoryLabel.text = string;//类型标签
    
    //使用SDWebImage方法下载图片
    NSURL *url = [NSURL URLWithString:rankListModel.cover];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"backImage"]];
    
}


@end
