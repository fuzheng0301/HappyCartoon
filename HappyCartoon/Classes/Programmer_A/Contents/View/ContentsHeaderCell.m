//
//  ContentsHeaderCell.m
//  Project_A
//
//  Created by 付正 on 15/6/1.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "ContentsHeaderCell.h"
#import "UIImageView+WebCache.h"
@implementation ContentsHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setComic:(Comic *)comic
{
//    设置属性
    _comic = comic;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:comic.cover] placeholderImage:[UIImage imageNamed:@"backImage"] completed:nil];
    self.name.text = comic.name;
    self.author_name.text = comic.author_name;
    self.theme_ids.text = comic.theme_ids;
    self.click_total.text = comic.click_total;
    self.image_all.text = [NSString stringWithFormat:@"%ld",(long)comic.image_all];
    self.contentDescription.text = comic.contectDescription;
}
//当单击此cell时,代理执行方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(touchDescription)])
    {
        [_delegate touchDescription];
    }
}


@end
