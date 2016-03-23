//
//  CategoryModel.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property(strong,nonatomic)NSString *sortName;//标题
@property(strong,nonatomic)NSString *cover;//图片网址
@property(nonatomic,strong)NSString *argValue;//下级标记值
@property(nonatomic,strong)NSString *argName;//下级标记名字

@end
