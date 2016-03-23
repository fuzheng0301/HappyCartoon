//
//  CartoonListsTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CartoonListsTableViewController.h"
#import "CartoonListTableViewCell.h"
#import "CartoonListsDetail.h"
#import "ContentsTableViewController.h"
#import "MJRefresh.h"

#define listUrl @"http://app.u17.com/v3/app/android/phone/list/index?size=40&page=1&argName=sort&argValue=0&con=3"
#define comicUrl @"http://app.u17.com/v3/app/android/phone/comic/detail?comicid=%@"
@interface CartoonListsTableViewController ()
@property (strong,nonatomic)NSMutableArray * cartoonArray;
@property (strong,nonatomic)PlaceHolderLabel * placeHolderLabel;
@end

@implementation CartoonListsTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.cartoonArray = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.title = @"更新";
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CartoonListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cartoonListCell"];
//    调用下拉刷新
    [self setupRefresh];
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
}
-(void)setupRefresh
{
//    设置下拉刷新所执行的动作
    [self.tableView addHeaderWithTarget:self action:@selector(JSON)];
//    开始刷新
    [self.tableView headerBeginRefreshing];
//    刷新阶段提示
    [self.tableView setHeaderPullToRefreshText:@"下拉刷新"];//下拉前
    [self.tableView setHeaderReleaseToRefreshText:@"松开即可刷新"];//下拉中
    [self.tableView setHeaderRefreshingText:@"拼命刷新中"];//下拉后
}

//网络请求,JSON解析
-(void)JSON
{
    __unsafe_unretained CartoonListsTableViewController * selfController = self;
    //网址是固定的
    NSURL * url = [NSURL URLWithString:listUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data == nil) {
//            NSLog(@"请求数据失败");
            [selfController.tableView headerEndRefreshing];
            [selfController.view addSubview:_placeHolderLabel];
            return ;
        }
        //清空数组,防止每次显示页面时,数组内容累加
        [_cartoonArray removeAllObjects];
        
        NSDictionary * dicSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dicData = dicSource[@"data"];
        NSArray * returnDataArray = dicData[@"returnData"];
        
//        取到数据字典
        for (NSDictionary * cartoonDic in returnDataArray) {
            CartoonListsDetail * detail = [[CartoonListsDetail alloc]init];
            [detail setValuesForKeysWithDictionary:cartoonDic];

            [_cartoonArray addObject:detail];
        }
        
        if (returnDataArray.count == 0)
            [selfController.tableView addSubview:_placeHolderLabel];
        else
            [_placeHolderLabel removeFromSuperview];
        
//        重载数据
        [selfController.tableView reloadData];
//        下拉刷新停止
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
    return _cartoonArray.count;
}
//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartoonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartoonListCell" forIndexPath:indexPath];
    
    //赋值model
    cell.detail = _cartoonArray[indexPath.row];
    
    //    设置图片圆角
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 10;
    //添加适应背景图片
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
    UIImage *img = [UIImage imageNamed:@"111.png"];
    [imgView setImage:img];
    cell.backgroundView = imgView;
    
    return cell;
    
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

//对选中cell进行操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    取model
    CartoonListsDetail * detail =_cartoonArray[indexPath.row];
//    拼网址
    __block NSString * urlString = [NSString stringWithFormat:comicUrl,detail.comic_id];
    
    ContentsTableViewController * contents = [[ContentsTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    导航栏
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:contents];
    //属性传值
    contents.urlString = urlString;
    contents.name = detail.name;
//    特效
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    模态推出
    [self presentViewController:NC animated:YES completion:nil];
}
@end
