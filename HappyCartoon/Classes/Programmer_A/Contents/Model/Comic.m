//
//  Comic.m
//  Project_A
//
//  Created by 付正 on 15/6/1.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "Comic.h"

@implementation Comic

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"])
    {
        self.contectDescription = value;
    }
}
@end
