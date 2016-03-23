//
//  LeftDrawerTableViewController.h
//  Project_A
//
//  Created by 付正 on 15/5/31.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PlaceHolderLabel.h"
@interface LeftDrawerTableViewController : UITableViewController<MBProgressHUDDelegate>
@property (strong, nonatomic)NSString * urlString;

@end
