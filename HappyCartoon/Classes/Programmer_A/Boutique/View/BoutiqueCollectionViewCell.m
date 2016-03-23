//
//  BoutiqueCollectionViewCell.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "BoutiqueCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation BoutiqueCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initObjects];
    }
    return self;
}
-(void)initObjects
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}
-(void)setBoutique:(Boutique *)boutique
{
    _boutique = boutique;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_boutique.cover] placeholderImage:[UIImage imageNamed:@"backImage"]];
    _name.text = _boutique.name;
}
@end
