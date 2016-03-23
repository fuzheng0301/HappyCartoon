//
//  CartoonListsDetail.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CartoonListsDetail.h"

@implementation CartoonListsDetail

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"])
    {
        self.cartoonDescription = value;
    }
//    tags是数组,拼接成字符串
    if ([key isEqualToString:@"tags"])
    {
//        取数组中的标题
        NSArray * tags = value;
        NSMutableString * tagTemp = [NSMutableString string];
        for (NSString * tag in tags)
        {
//            标题拼接成字符串赋值给属性
            self.cartoonTag = [tagTemp stringByAppendingString:[NSString stringWithFormat:@"/%@",tag]];
            tagTemp = [NSMutableString stringWithString:self.cartoonTag];
        }
    }
}

@end
