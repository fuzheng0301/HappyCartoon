//
//  RankModel.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject

@property(nonatomic,strong)NSString *rankingName;//名字
@property(nonatomic,strong)NSString *rankingDescription1;//简介
@property(nonatomic,strong)NSString *rankingDescription2;//简介2
@property(nonatomic,strong)NSString *cover;//图片网址
@property(nonatomic,strong)NSString *argValue;//参数值
@property(nonatomic,strong)NSString *argName;//标记

@end
