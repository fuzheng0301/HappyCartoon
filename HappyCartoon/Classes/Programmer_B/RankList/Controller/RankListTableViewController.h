//
//  RankListTableViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/30.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsTableViewController.h"
#import "MJRefresh.h"
#import "RankListTableViewCell.h"
#import "Url.h"
#import "PlaceHolderLabel.h"
@interface RankListTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray *rankListArray;//存放数据的数组
@property(nonatomic,strong)NSString * urlString;


@end
