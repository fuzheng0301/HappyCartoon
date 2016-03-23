//
//  CartoonListsDetail.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartoonListsDetail : NSObject

@property (strong,nonatomic)NSString * comic_id;//标识
@property (strong,nonatomic)NSString * name;//名字
@property (strong,nonatomic)NSString * cover;//缩略图
@property (strong,nonatomic)NSString * last_update_chapter_name;//最后更新章节
@property (strong,nonatomic)NSString * nickname;//作者
@property (strong,nonatomic)NSString * cartoonDescription;//描述
@property (strong,nonatomic)NSString * click_total;
@property (strong,nonatomic)NSString * cartoonTag;//标签
@end
