//
//  RankTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "RankTableViewController.h"
#import "RankListTableViewController.h"
#import "RankTableViewCell.h"
#import "MJRefresh.h"

@interface RankTableViewController ()
@property (strong,nonatomic)PlaceHolderLabel * placeHolderLabel;
@end

@implementation RankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏设置
    self.navigationItem.title = @"排行";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RankTVCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //开辟空间
    self.rankArray = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //到顶部刷新
    [self setupRefresh];
    //断网占位提示
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width, 44)];

}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(loadWeb)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉即可刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.headerRefreshingText = @"正在努力刷新中....";
    
}

#pragma mark-----GET请求网络数据
-(void)loadWeb
{

    //创建网址对象
    NSURL *url = [NSURL URLWithString:RankUrl];
    //创建网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    //连接并发送请求
    __weak RankTableViewController *rankTVC = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
//            NSLog(@"请求数据失败");
            [rankTVC.tableView headerEndRefreshing];
            [rankTVC.tableView addSubview:_placeHolderLabel];
            return ;
        }
        //清空数组,防止每次显示页面时,数组内容累加
        [_rankArray removeAllObjects];
        
        //解析请求过来的data
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //接收字典中对应的小字典
        NSDictionary *dict = [dic objectForKey:@"data"];
        //下级字典
        NSDictionary *diction = [dict objectForKey:@"returnData"];
        //接收下一级的字典
        NSArray *arr = [diction objectForKey:@"rankinglist"];
        //遍历小字典
        for (NSDictionary *d in arr) {
            RankModel *rankModel = [[RankModel alloc]init];
            [rankModel setValuesForKeysWithDictionary:d];
            [rankTVC.rankArray addObject:rankModel];
        }
        if (arr.count == 0)
            [rankTVC.tableView addSubview:_placeHolderLabel];
        else
            [_placeHolderLabel removeFromSuperview];
        [rankTVC.tableView reloadData];
        [rankTVC.tableView headerEndRefreshing];
        
    }];
    
}

//行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _rankArray.count;
}
//区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //从数组中获取对应的model对象
     cell.rankModel= _rankArray[indexPath.row];
    //    设置图片圆角
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 10;
//    [cell setBackgroundImageByName:@"111.png"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
    UIImage *img = [UIImage imageNamed:@"111.png"];
    [imgView setImage:img];
    cell.backgroundView = imgView;
    
    return cell;
}

//推出界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取model
    RankModel * model = _rankArray[indexPath.row];
    //拼接网址
    __block NSString * urlString = [NSString stringWithFormat:@"%@&argValue=%@&argName=%@",RankListUrl,model.argValue,model.argName];
    
    RankListTableViewController *rankListView = [[RankListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    //设导航
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:rankListView];
    //设置标题
    rankListView.navigationItem.title = model.rankingName;
    //属性传值
    rankListView.urlString = urlString;
    //特效
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //推出
    [self presentViewController:NC animated:YES completion:nil];
    
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


@end
