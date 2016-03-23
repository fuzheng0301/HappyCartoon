//
//  SearchViewController.h
//  Project_A
//
//  Created by 付正 on 15/6/4.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderLabel.h"
@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PlaceHolderLabel * placeHolderLabel;

@end
