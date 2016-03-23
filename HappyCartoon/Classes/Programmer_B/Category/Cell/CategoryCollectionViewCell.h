//
//  CategoryCollectionViewCell.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "UIImageView+WebCache.h"
@interface CategoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imagView;
@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) CategoryModel *categoryModel;

@end
