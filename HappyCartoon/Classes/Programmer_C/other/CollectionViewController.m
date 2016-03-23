//
//  CollectionViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CollectionViewController.h"
#import "DBmanger.h"
#import "NoticeViewController.h"
#import "CollectionTableViewController.h"
#import "HistoryTableViewController.h"

@interface CollectionViewController ()

@property (strong, nonatomic)CollectionTableViewController * collectionTVC;
@property (strong, nonatomic)HistoryTableViewController * historyTVC;
@property (strong, nonatomic)UIBarButtonItem * historyBI;
@property (strong, nonatomic)UIBarButtonItem * collectionBI;
@property (strong, nonatomic)UISegmentedControl * segment;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createBarButton];
    [self createControllers];
    [self createSegment];
}

-(void)createControllers
{
    //收藏界面
    self.collectionTVC = [[CollectionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.collectionTVC.view.backgroundColor = [UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000];
    
    //历史界面
    self.historyTVC = [[HistoryTableViewController alloc ] initWithStyle:UITableViewStylePlain];
    self.historyTVC.view.backgroundColor = [UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    //添加
    [self addChildViewController:_collectionTVC];
    [self addChildViewController:_historyTVC];
    //添加视图
    [self.view addSubview:_historyTVC.view];
    [self.view addSubview:_collectionTVC.view];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //设置右边声明按钮
    UIBarButtonItem * noticeBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"notice.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didToNotic)];
    noticeBI.tintColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    self.navigationItem.rightBarButtonItem = noticeBI;
    
}
-(void)createSegment
{
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"  收藏   ",@"  历史  "]];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
    
    _segment.backgroundColor = [UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000];
    _segment.tintColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    
    [self.navigationItem setTitleView:_segment];
}
-(void)clickSegment:(UISegmentedControl*)segment
{
    if (segment.selectedSegmentIndex == 0)
    {
        [self.view bringSubviewToFront:_collectionTVC.tableView];
        //设置右边声明按钮
        UIBarButtonItem * noticeBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"notice.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didToNotic)];
        noticeBI.tintColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        self.navigationItem.rightBarButtonItem = noticeBI;
        
    }
    if (segment.selectedSegmentIndex == 1)
    {
        [self.view bringSubviewToFront:_historyTVC.tableView];
        //设置右边清空按钮
        UIBarButtonItem * rightBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"trash.png"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllHistory)];
        rightBI.tintColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        self.navigationItem.rightBarButtonItem = rightBI;
    }
}
-(void)didToNotic
{
    NoticeViewController *noticeVC = [[NoticeViewController alloc]init];
    [noticeVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:noticeVC animated:YES completion:nil];
    
}

//清空按钮实现方法
-(void)deleteAllHistory
{
    
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"确定要全部清空吗？" preferredStyle:UIAlertControllerStyleAlert];
    //创建按钮
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableArray *historyArr = [[DBmanger sharedInstance]selectAllHistory];
        for (HistotyModel *model in historyArr) {
            [[DBmanger sharedInstance]deleteHistoryNewsByUrl:model.name];
        }
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delateAllHistory" object:nil];
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    //添加按钮
    [alertCtr addAction:firstAction];
    [alertCtr addAction:secondAction];
    
    [self presentViewController:alertCtr animated:YES completion:^{
        
    }];
}
@end
