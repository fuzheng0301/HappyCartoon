//
//  CategoryCollectionViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryCollectionViewCell.h"
#import "RankListTableViewController.h"
#import "UIImageView+WebCache.h"
#import "CategoryModel.h"
#import "PlaceHolderLabel.h"
@interface CategoryCollectionViewController : UICollectionViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *categoryArray;


@end
