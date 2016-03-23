//
//  Recommend.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Boutique.h"
@interface Recommend : NSObject

@property (strong,nonatomic)NSString * argValue;//数值标识	用来标识”更多”页面
@property (strong,nonatomic)NSString * argName;//名字标识	用来标识”更多”页面
@property (strong,nonatomic)NSString * title;//	标题	作品等级推荐
@property (strong,nonatomic)NSString * titleIconUrl;//标题Icon	标题的Icon图标
@property (strong,nonatomic)NSString * titleWithIcon;//Icon标题	拼接在Icon后的标题

@end
