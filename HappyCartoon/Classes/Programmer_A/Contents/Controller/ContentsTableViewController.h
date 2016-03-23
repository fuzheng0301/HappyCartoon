//
//  ContentsTableViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsHeaderCell.h"
#import "RankListModel.h"
#import "DBmanger.h"
#import "HistotyModel.h"
#import "PlaceHolderLabel.h"
@interface ContentsTableViewController : UITableViewController<ContentsHeaderCellDelegate>

@property (strong, nonatomic) NSString * urlString;
@property (strong, nonatomic) NSString *name;
@property (strong,nonatomic)RankListModel * rankDetal;

@property (strong,nonatomic)NSData *dataCommon;

@end
