//
//  HistoryTableViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryListTableViewController.h"
#import "HistoryTableViewCell.h"
#import "HistotyModel.h"
#import "DBmanger.h"
#import "PlaceHolderLabel.h"
@interface HistoryTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray *historyArray;
@property(nonatomic,strong)HistotyModel *historyModel;

@end
