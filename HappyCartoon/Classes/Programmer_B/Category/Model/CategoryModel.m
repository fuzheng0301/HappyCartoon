//
//  CategoryModel.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",_sortName];
}

@end
