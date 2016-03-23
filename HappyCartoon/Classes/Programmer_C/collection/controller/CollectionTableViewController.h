//
//  CollectionTableViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionListTableViewController.h"
#import "CollectionTableViewCell.h"
#import "CollectionModel.h"
#import "DBmanger.h"
#import "PlaceHolderLabel.h"
@interface CollectionTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray *collectionArray;
@property(nonatomic,strong)CollectionModel *collectionModel;

@end
