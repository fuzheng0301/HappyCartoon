//
//  CollectionTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CollectionTableViewController.h"

@interface CollectionTableViewController ()
@property (strong,nonatomic)PlaceHolderLabel *placeHolderLabel;
@end

@implementation CollectionTableViewController

//设置旋转时列表位置精度
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    static int page = 0;

        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 113);
        page++;
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    _placeHolderLabel.text = @"暂无收藏数据";
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Collection" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.collectionArray = [NSMutableArray array];
    
    //接收收藏成功通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didCollect) name:@"collect" object:nil];
    //接收收藏失败通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didExitCollet) name:@"exitCollect" object:nil];
    
    [self loadData];
    
}
-(void)addRightButton
{
    
}

//通知方法
-(void)didCollect
{
    [self loadData];
    [self.tableView reloadData];
}
-(void)didExitCollet
{
    [self loadData];
    [self.tableView reloadData];
}

//加载数据
-(void)loadData
{
    
    self.collectionArray = [[DBmanger sharedInstance]selectAllCollection];

    if (_collectionArray.count == 0 && _placeHolderLabel.superview == nil)
            [self.tableView addSubview:_placeHolderLabel];
    if (_collectionArray.count != 0)
            [_placeHolderLabel removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _collectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.collectionModel = _collectionArray[_collectionArray.count - indexPath.row - 1];
    //    设置图片圆角
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 10;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
    UIImage *img = [UIImage imageNamed:@"111.png"];
    [imgView setImage:img];
    cell.backgroundView = imgView;
    
    return cell;
}

#pragma mark------tableView编辑(删除,插入)
//1.编辑第一步:让tableView处于可以编辑状态
//此setEditing:animated: 方法是允许viewController上的所有的视图可以处于编辑装备
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    [super setEditing:editing animated:animated];
    //让tableView可以处于编辑状态
    [self.tableView setEditing:editing animated:YES];
}
//2.编辑第二步:设置指定分区(section)中的行(row)是否可以被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//3.编辑第三步:设置指定分区(section)中的行(row)是什么编辑样式(删除)
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;//删除样式
}
//4.编辑第四步:编辑完成(先操作数据源(M层),再修改UI(V层))
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"真的要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    //创建按钮
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //①.删除数据库
        _collectionModel = [[CollectionModel alloc]init];
        _collectionModel = _collectionArray[indexPath.row];
        NSString *name = _collectionModel.name;
        [[DBmanger sharedInstance ]deleteCollectionNewsByUrl:name];
        //删除数据
        [_collectionArray removeObject:_collectionModel];
        //②.删除UI
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
        
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    //添加按钮
    [alertCtr addAction:firstAction];
    [alertCtr addAction:secondAction];
    //显示弹出框
    [self presentViewController:alertCtr animated:YES completion:^{
        
    }];
    
}


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionModel * detail =_collectionArray[_collectionArray.count - 1 - indexPath.row];
    //初始化
    CollectionListTableViewController * contents = [[CollectionListTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
