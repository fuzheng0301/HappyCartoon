//
//  RankListModel.h
//  Project_A
//
//  Created by 付正 on 15/5/30.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankListModel : NSObject

@property(nonatomic,strong)NSString *name;//标题
@property(nonatomic,strong)NSString *cover;//图片网址
@property(nonatomic,strong)NSArray *tags;//分类标签
@property(nonatomic,strong)NSString *click_total;//投票数
@property(nonatomic,strong)NSString *extraValue;//本月月票
@property(nonatomic,strong)NSString *nickname;//作者
@property (strong,nonatomic)NSString * comic_id;//标识

@end
