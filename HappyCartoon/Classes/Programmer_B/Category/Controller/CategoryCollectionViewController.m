//
//  CategoryCollectionViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "CategoryCollectionViewController.h"
#import "CategoryCollectionViewCell.h"
#import "MJRefresh.h"
@interface CategoryCollectionViewController ()
@property (strong,nonatomic)PlaceHolderLabel * placeHolderLabel;
@end

@implementation CategoryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置
    self.navigationItem.title = @"分类";
    
    //设置布局样式
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //每个item尺寸
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width-60)/3, 120);
    
    //设置内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //△.添加
    self.collectionView.collectionViewLayout = flowLayout;
    
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCVCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //开辟空间
    self.categoryArray = [NSMutableArray array];
    
    // 集成刷新控件
    [self addHeader];
    
    //断网占位提示
    if (!_placeHolderLabel)
    self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, 44)];
}
- (void)addHeader
{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addHeaderWithTarget:self action:@selector(loadWeb)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.collectionView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.collectionView.headerPullToRefreshText = @"下拉即可刷新了";
    self.collectionView.headerReleaseToRefreshText = @"松开即可刷新";
    self.collectionView.headerRefreshingText = @"正在努力刷新中....";
    
}


-(void)loadWeb
{
    
    //创建网址对象
    NSURL *url = [NSURL URLWithString:CategoryUrl];
    //创建网络请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    //连接并发送请求
    __weak CategoryCollectionViewController *categoryCVC = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil) {
//            NSLog(@"请求数据失败");
            [categoryCVC.collectionView headerEndRefreshing];
            [categoryCVC.collectionView addSubview:_placeHolderLabel];
            return ;
        }
        //清空数组,防止每次显示页面时,数组内容累加
        [_categoryArray removeAllObjects];
        
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
            CategoryModel *categoryModel = [[CategoryModel alloc]init];
            [categoryModel setValuesForKeysWithDictionary:d];
            [categoryCVC.categoryArray addObject:categoryModel];
        }
        if (arr.count == 0)
            [categoryCVC.collectionView addSubview:_placeHolderLabel];
        else
            [_placeHolderLabel removeFromSuperview];
        [categoryCVC.collectionView reloadData];
        
        [categoryCVC.collectionView headerEndRefreshing];
        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    NSLog(@"%ld",_categoryArray.count);
    return _categoryArray.count;
    
}

#pragma mark-------item的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //从数组中获取对应的model对象
    CategoryModel *model = self.categoryArray[indexPath.item];
    //    设置图片圆角
    cell.imagView.layer.masksToBounds = YES;
    cell.imagView.layer.cornerRadius = 10;
    cell.categoryModel = model;
    
    return cell;
}
//推出界面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RankListTableViewController *rankListTVC = [[RankListTableViewController alloc]init];
    //获取item内容
    CategoryModel * model = _categoryArray[indexPath.row];
    //拼接网址
    __block NSString * urlString = [NSString stringWithFormat:@"%@&argValue=%@&argName=%@",RankListUrl,model.argValue,model.argName];
    //设导航
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:rankListTVC];
    //设置标题
    rankListTVC.navigationItem.title = model.sortName;
    //属性传值
    rankListTVC.urlString = urlString;
    //特效
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //推出
    [self presentViewController:NC animated:YES completion:nil];
    
}

@end
