//
//  HistoryTableViewCell.h
//  Project_A
//
//  Created by 付正 on 15/6/8.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistotyModel.h"
#import "UIImageView+WebCache.h"
@interface HistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *historyImg;
@property (strong, nonatomic) IBOutlet UILabel *historyName;
@property (strong, nonatomic) IBOutlet UILabel *historyAutorName;

@property(strong, nonatomic) HistotyModel *historyModel;

@end
