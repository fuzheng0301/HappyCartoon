//
//  RankListTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/30.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "RankListTableViewController.h"

@interface RankListTableViewController ()
@property (strong,nonatomic)PlaceHolderLabel * placeHolderLabel;
@end

@implementation RankListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加背景
    UIImageView *rankimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *rankimg = [UIImage imageNamed:@"109.png"];
    [rankimgView setImage:rankimg];
    self.tableView.backgroundView= rankimgView;
    
    //设置返回按钮
    UIBarButtonItem *leftBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParentController)];
    leftBI.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = leftBI;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"RankList" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //开辟数组
    self.rankListArray = [NSMutableArray array];
    
    //刷新
    [self setupRefresh];
    
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width, 44)];
}

-(void)backToParentController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    NSURL *url = [NSURL URLWithString:_urlString];
    //创建网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    //连接并发送请求
    __weak RankListTableViewController *rankListTVC = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
//            NSLog(@"请求数据失败");
            [rankListTVC.tableView headerEndRefreshing];
            [rankListTVC.tableView addSubview:_placeHolderLabel];
            return ;
        }
        //清空数组,防止每次显示页面时,数组内容累加
        [_rankListArray removeAllObjects];
        
        //解析请求过来的data
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //接收字典中对应的小字典
        NSDictionary *dict = [dic objectForKey:@"data"];
        //下级数组
        NSArray *array = [dict objectForKey:@"returnData"];
        //遍历小字典
        for (NSDictionary *d in array) {
            RankListModel *rankListModel = [[RankListModel alloc]init];
            [rankListModel setValuesForKeysWithDictionary:d];
            [rankListTVC.rankListArray addObject:rankListModel];
        }
        if (array.count == 0)
            [rankListTVC.tableView addSubview:_placeHolderLabel];
        else
            [_placeHolderLabel removeFromSuperview];
        
        [rankListTVC.tableView reloadData];
        [rankListTVC.tableView headerEndRefreshing];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _rankListArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%@",rankList);
    RankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.rankListModel = _rankListArray[indexPath.row];
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


//添加行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RankListModel * detail =_rankListArray[indexPath.row];
//    NSLog(@"detail = %@",detail);
    //拼接网址
    __block NSString * urlString = [NSString stringWithFormat:@"http://app.u17.com/v3/app/android/phone/comic/detail?comicid=%@",detail.comic_id];
    //初始化
    ContentsTableViewController * contents = [[ContentsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //设置导航栏
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:contents];
    //给网址
    contents.urlString = urlString;
    contents.name = detail.name;
    //设置模态样式
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //模态推出
    [self presentViewController:NC animated:YES completion:nil];
    
}

@end
