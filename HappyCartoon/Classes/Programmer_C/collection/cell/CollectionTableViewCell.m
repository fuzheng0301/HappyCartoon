//
//  CollectionTableViewCell.m
//  Project_A
//
//  Created by 付正 on 15/6/5.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell

-(void)setCollectionModel:(CollectionModel *)collectionModel
{
    _collectionModel = collectionModel;
    
    //使用SDWebImage方法下载图片
    NSURL *url = [NSURL URLWithString:collectionModel.cover];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"backImage"]];
    
    self.nameLabel.text = collectionModel.name;
    self.writerNameLabel.text = collectionModel.author;
    
}


@end
