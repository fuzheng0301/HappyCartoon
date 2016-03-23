//
//  CartoonListTableViewCell.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CartoonListTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CartoonListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDetail:(CartoonListsDetail *)detail
{
    _detail = detail;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:detail.cover] placeholderImage:[UIImage imageNamed:@"backImage"]];
    self.name.text = detail.name;
    self.nickName.text = detail.nickname;
    self.lastChapter.text = detail.last_update_chapter_name;
    self.click_totals.text = detail.click_total;
    self.cartoonTag.text = detail.cartoonTag;
}

@end
