//
//  Comic.h
//  Project_A
//
//  Created by 付正 on 15/6/1.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comic : NSObject

@property (strong,nonatomic)NSString * name;//	漫画名
@property (strong,nonatomic)NSString * author_name;//	作者名
@property (strong,nonatomic)NSString * cover;//	缩略图URl
@property (strong,nonatomic)NSString * theme_ids;//	分类	少年/科幻/推理/恐怖
@property (strong,nonatomic)NSString * cate_id;//	类型	故事漫画
@property (strong,nonatomic)NSString * click_total;//	总点击
@property (assign,nonatomic)NSInteger total_tucao;//	总吐槽
@property (assign,nonatomic)NSInteger month_ticket;//	本月月票
@property (assign,nonatomic)NSInteger total_ticket;//	总月票
@property (assign,nonatomic)NSInteger image_all;//	总图片
@property (assign,nonatomic)NSInteger comment_total;//	总评论
@property (strong,nonatomic)NSString * last_update_time;//更新时间
@property (strong,nonatomic)NSString * contectDescription;//	描述	《端脑》简介

@property (nonatomic, assign)BOOL isFavorite;
@property (nonatomic, assign)BOOL isHistory;
@end
