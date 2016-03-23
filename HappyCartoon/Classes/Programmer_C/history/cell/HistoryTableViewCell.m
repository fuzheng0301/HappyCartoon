//
//  HistoryTableViewCell.m
//  Project_A
//
//  Created by 付正 on 15/6/8.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

-(void)setHistoryModel:(HistotyModel *)historyModel
{
    _historyModel = historyModel;
    
    //使用SDWebImage方法下载图片
    NSURL *url = [NSURL URLWithString:historyModel.cover];
    [self.historyImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"backImage"]];
    
    self.historyName.text = historyModel.name;
    self.historyAutorName.text = historyModel.author;
    
}



@end
