//
//  CategoryCollectionViewCell.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

-(void)setCategoryModel:(CategoryModel *)categoryModel
{
    //使用SDWebImage方法下载图片
    NSURL *url = [NSURL URLWithString:categoryModel.cover];
    [self.imagView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"backImage"]];
    
    //标题
    self.title.text = categoryModel.sortName;
    
}

@end
