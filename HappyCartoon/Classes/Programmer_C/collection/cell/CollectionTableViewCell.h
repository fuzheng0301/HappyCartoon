//
//  CollectionTableViewCell.h
//  Project_A
//
//  Created by 付正 on 15/6/5.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
#import "UIImageView+WebCache.h"
@interface CollectionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *writerNameLabel;

@property(strong, nonatomic) CollectionModel *collectionModel;

@end
