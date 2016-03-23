//
//  LeftDrawerTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/31.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "LeftDrawerTableViewController.h"
#import "UIImageView+WebCache.h"
#import "BoutiqueCollectionViewController.h"
#import "Recommend.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#define sUrl @"http://app.u17.com/v3/app/ios/phone/list/index?size=40&page=1&argName=topic&argValue=8&con=0"
#define recommendUrl @"http://app.u17.com/v3/app/ios/phone/recommend/itemlist"
#define recommendChangeUrl @"http://app.u17.com/v3/app/ios/phone/list/index?size=40&page=1&argName=%@&argValue=%@&con=0"
@interface LeftDrawerTableViewController ()

@property (strong, nonatomic)NSMutableArray * recomendArray;
@property (strong, nonatomic)PlaceHolderLabel * placeHolderLabel;
@end

@implementation LeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"103.png"]]] ;
    
    self.recomendArray = [NSMutableArray array];
    self.urlString = sUrl;
    self.navigationItem.title = @"推荐";
    self.tableView.tableFooterView = [[UIView alloc]init];
    //下拉刷新
    [self setupRefresh];
    //断网占位提示
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0,150, 44)];
}

//下拉刷新
- (void)setupRefresh
{
    // 下拉刷新方法
    [self.tableView addHeaderWithTarget:self action:@selector(JSON)];
    //开始刷新
    [self.tableView headerBeginRefreshing];
    //    三个阶段的标题
    self.tableView.headerPullToRefreshText = @"下拉即可刷新了";//下拉前
    self.tableView.headerReleaseToRefreshText = @"松开即可刷新";//下拉中
    self.tableView.headerRefreshingText = @"正在努力刷新中....";//松开后
}
-(void)JSON
{
    __unsafe_unretained LeftDrawerTableViewController * selfController = self;
//    网址固定
    NSURL * url = [NSURL URLWithString:recommendUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data == nil) {
//            NSLog(@"网络请求失败");
            [selfController.tableView headerEndRefreshing];
            if (_placeHolderLabel.superview == nil)
                [selfController.tableView addSubview:_placeHolderLabel];
            return ;
        }
        [_recomendArray removeAllObjects];
        NSDictionary * dicSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dicData = dicSource[@"data"];
        NSArray * returnDataArray = dicData[@"returnData"];
        for (NSDictionary * recommendDic in returnDataArray)
        {
            Recommend * recommend = [[Recommend alloc] init];
            [recommend setValuesForKeysWithDictionary:recommendDic];
            [_recomendArray addObject:recommend];
        }
        
        if (returnDataArray.count == 0 &&_placeHolderLabel.superview == nil)
            [selfController.tableView addSubview:_placeHolderLabel];
        if (returnDataArray.count != 0)
            [_placeHolderLabel removeFromSuperview];
//        index = 0 是 galleryItems,用不到
        [_recomendArray removeObjectAtIndex:0];
//        最后一项也用不到
        [_recomendArray removeLastObject];
//        重载数据
        [selfController.tableView reloadData];
        [selfController.tableView headerEndRefreshing];
    }];
    
}
//区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recomendArray.count;
}
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor=[UIColor clearColor];
    Recommend * recommend = _recomendArray[indexPath.row];
    cell.textLabel.text = recommend.title;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    取model 
    Recommend * recommend = _recomendArray[indexPath.row];
//    根据点击的不同传递不同的网址
    self.urlString = [NSString stringWithFormat:recommendChangeUrl,recommend.argName,recommend.argValue];
//    发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"urlString" object:self userInfo:@{@"urlString":_urlString}];
}

@end
