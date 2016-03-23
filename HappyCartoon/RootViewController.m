//
//  RootViewController.m
//  Project_A
//
//  Created by 付正 on 15/6/1.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "RootViewController.h"
#import "CollectionViewController.h"
#import "BoutiqueCollectionViewController.h"
#import "CartoonListsTableViewController.h"
#import "RankTableViewController.h"
#import "CategoryCollectionViewController.h"

#import "MMDrawerController.h"
#import "LeftDrawerTableViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //键collertion默认样式
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //精品
    BoutiqueCollectionViewController * boutiqueCVC = [[BoutiqueCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    boutiqueCVC.collectionView.alwaysBounceVertical = YES;
    UINavigationController * boutiqueNC = [[UINavigationController alloc] initWithRootViewController:boutiqueCVC];
    //添加背景
    UIImageView *boutiqueimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *boutiqueimg = [UIImage imageNamed:@"109.png"];
    [boutiqueimgView setImage:boutiqueimg];
    boutiqueCVC.collectionView.backgroundView= boutiqueimgView;
    //    boutiqueNC.tabBarItem.title = @"推荐";
    
    //更新列表
    CartoonListsTableViewController * cartoonListsTVC = [[CartoonListsTableViewController alloc] init];
    UINavigationController * cartoonListsNC = [[UINavigationController alloc] initWithRootViewController:cartoonListsTVC];
    cartoonListsNC.tabBarItem.title = @"更新";
    //添加背景
    UIImageView *cartoonListsimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *cartoonListsimg = [UIImage imageNamed:@"109.png"];
    [cartoonListsimgView setImage:cartoonListsimg];
    cartoonListsTVC.tableView.backgroundView= cartoonListsimgView;
    
    //排行
    RankTableViewController * rankTVC = [[RankTableViewController alloc] init];
    UINavigationController * rankNC = [[UINavigationController alloc] initWithRootViewController:rankTVC];
    rankNC.tabBarItem.title = @"排行";
    //添加背景
    UIImageView *rankimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *rankimg = [UIImage imageNamed:@"109.png"];
    [rankimgView setImage:rankimg];
    rankTVC.tableView.backgroundView= rankimgView;
    
    //分类
    CategoryCollectionViewController * categoryCVC = [[CategoryCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    categoryCVC.collectionView.alwaysBounceVertical = YES;
    UINavigationController * categoryNC = [[UINavigationController alloc] initWithRootViewController:categoryCVC];
    
    categoryNC.tabBarItem.title = @"分类";
    //添加背景
    UIImageView *categoryimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *categoryimg = [UIImage imageNamed:@"109.png"];
    [categoryimgView setImage:categoryimg];
    categoryCVC.collectionView.backgroundView= categoryimgView;
    
    //收藏
    CollectionViewController * collectionVC = [[CollectionViewController alloc] init];
    UINavigationController * collectionNC = [[UINavigationController alloc] initWithRootViewController:collectionVC];
    collectionNC.tabBarItem.title = @"收藏";
    
    //左抽屉TVC
    LeftDrawerTableViewController * leftTVC = [[LeftDrawerTableViewController alloc] init];
    //    加导航
    UINavigationController * leftNC = [[UINavigationController alloc] initWithRootViewController:leftTVC];
    //    建抽屉,设置中心视图和左抽屉
    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:boutiqueNC leftDrawerViewController:leftNC];
    drawerController.tabBarItem.title = @"推荐";
    //    抽屉宽度
    drawerController.maximumLeftDrawerWidth = 150;
    //滑动手势快关抽屉
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];//拉出抽屉
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];//推回抽屉
    
    NSArray * tabBarItems = @[drawerController,cartoonListsNC,rankNC,categoryNC,collectionNC];
    self.viewControllers = tabBarItems;
    
    //设置工程中所有导航控制器中导航栏的背景图片
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000]];
    
    //设置tabbar的图片
    categoryNC.tabBarItem.image = [UIImage imageNamed:@"category-1.png"];
    rankNC.tabBarItem.image = [UIImage imageNamed:@"rank.png"];
    drawerController.tabBarItem.image = [UIImage imageNamed:@"recommend.png"];
    cartoonListsNC.tabBarItem.image = [UIImage imageNamed:@"refresh.png"];
    collectionNC.tabBarItem.image = [UIImage imageNamed:@"collection.png"];
    
    //标签视图控制器背景
    self.tabBar.barTintColor = [UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000];
    
    //界面背景
    boutiqueCVC.collectionView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"109.png"]];
    cartoonListsTVC.tableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"109.png"]];
    rankTVC.tableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"109.png"]];
    categoryCVC.collectionView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"109.png"]];
    collectionVC.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"109.png"]];
    
}
-(void)didReceiveMemoryWarning
{
    [[SDImageCache sharedImageCache] clearMemory];
    
    // 赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
