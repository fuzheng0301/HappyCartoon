//
//  PlaceHolderLabel.m
//  Project_A
//
//  Created by 付正 on 15/6/11.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "PlaceHolderLabel.h"

@implementation PlaceHolderLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        self.text = @"网络异常,请检查网络后,下拉刷新";
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor grayColor];
    }
    return self;
}

@end
