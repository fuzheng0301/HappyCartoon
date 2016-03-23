//
//  HistoryTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "HistoryTableViewController.h"

@interface HistoryTableViewController ()
@property (nonatomic,strong) PlaceHolderLabel * placeHolderLabel;
@end

@implementation HistoryTableViewController

//设置旋转时列表位置精度
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 113);
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    _placeHolderLabel.text = @"暂无历史数据";
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"History" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.historyArray = [NSMutableArray array];
    
    //接收历史存储成功通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didHistory) name:@"history" object:nil];
    //接收清空历史
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delateAllHistory) name:@"delateAllHistory" object:nil];
    
    
    //读取数据
    [self loadData];
    
}
-(void)delateAllHistory
{
    
    [self loadData];
    [self.tableView reloadData];
    
}

//通知方法
-(void)didHistory
{
    [self loadData];
    [self.tableView reloadData];
}

//加载数据
-(void)loadData
{
    
    self.historyArray = [[DBmanger sharedInstance]selectAllHistory];
    
    if (_historyArray.count == 0 && _placeHolderLabel.superview == nil)
        [self.tableView addSubview:_placeHolderLabel];
    if (_historyArray.count != 0)
        [_placeHolderLabel removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.historyModel = _historyArray[_historyArray.count - indexPath.row - 1];
//    设置图片圆角
    cell.historyImg.layer.masksToBounds = YES;
    cell.historyImg.layer.cornerRadius = 10;
    //添加适应背景图片
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
//    NSLog(@"%f",self.view.frame.size.width);
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

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistotyModel * detail =_historyArray[_historyArray.count - 1 - indexPath.row];
    //初始化
    HistoryListTableViewController * contents = [[HistoryListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //设置导航栏
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:contents];
    //给名字
    contents.name = detail.name;
    //设置模态样式
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //模态推出
    [self presentViewController:NC animated:YES completion:nil];
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}


@end
