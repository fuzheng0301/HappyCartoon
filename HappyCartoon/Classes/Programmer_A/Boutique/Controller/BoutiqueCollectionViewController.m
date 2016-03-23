//
//  BoutiqueCollectionViewController.m
//  Project_A
//
//  Created by 付正 on 15/6/11.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//
#import "BoutiqueCollectionViewController.h"
#import "BoutiqueCollectionViewCell.h"
#import "LeftDrawerTableViewController.h"
#import "ContentsTableViewController.h"
#import "SearchViewController.h"
#import "Boutique.h"
#import "MJRefresh.h"
#define sUrl @"http://app.u17.com/v3/app/ios/phone/list/index?size=40&page=1&argName=topic&argValue=8&con=0"
#define comicUrl @"http://app.u17.com/v3/app/android/phone/comic/detail?comicid=%@"
#define Width (self.view.frame.size.width - 60)
@interface BoutiqueCollectionViewController ()

@property (strong,nonatomic)NSMutableArray * recommendArray;
@property (strong,nonatomic)NSString * urlString;
@property (strong,nonatomic)PlaceHolderLabel * placeHolderLabel;

@end

@implementation BoutiqueCollectionViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"urlString" object:nil];
}
//-(void)loadView{
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recommendArray = [NSMutableArray array];
    //    初始化网址
    self.urlString = sUrl;
    [self setCollectionView];
    //下拉刷新
    [self setupRefresh];
    //侧滑抽屉
    [self setupLeftMenuButton];
    //注册通知,通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUrlString:) name:@"urlString" object:nil];
        //断网占位提示
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, 44)];
}
-(void)changeUrlString:(NSNotification*)notification
{
    //    收到通知,取出通知消息
    NSDictionary * urlStringDic = [notification userInfo];
    //    取出网址
    NSString * urlStringTemp = urlStringDic[@"urlString"];
    //    若网址改变,更新网址,并下拉刷新数据
    if (self.urlString != urlStringTemp)
    {
        self.urlString = urlStringTemp;
        [self setupRefresh];
    }
}
//下拉刷新
- (void)setupRefresh
{
    // 下拉刷新方法
    [self.collectionView addHeaderWithTarget:self action:@selector(JSON)];
    //开始刷新
    [self.collectionView headerBeginRefreshing];
    //    三个阶段的标题
    self.collectionView.headerPullToRefreshText = @"下拉即可刷新了";//下拉前
    self.collectionView.headerReleaseToRefreshText = @"松开即可刷新";//下拉中
    self.collectionView.headerRefreshingText = @"正在努力刷新中....";//松开后
}
//Collection设置
-(void)setCollectionView
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //    注册xib
    [self.collectionView  registerNib:[UINib nibWithNibName:@"BoutiqueCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"boutiqueCell"];
    //    样式
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //    样式属性
    flowLayout.itemSize = CGSizeMake(Width/3, 120);//item的Frame
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动方向
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//item上下左右间距
    self.collectionView.collectionViewLayout = flowLayout;//添加样式
    
    //Set NavigationController
    self.navigationItem.title = @"推荐";
    
    //    设置rightBI
    UIBarButtonItem * rightBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchICO"] style:UIBarButtonItemStylePlain target:self action:@selector(searchComic)];
    rightBI.tintColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBI;
}
//网络请求与解析
-(void)JSON
{
    __unsafe_unretained BoutiqueCollectionViewController * selfController = self;
    NSURL * url = [NSURL URLWithString:_urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         
         if (data == nil) {
             //            NSLog(@"返回数据为空");
             [selfController.collectionView headerEndRefreshing];
             if (_recommendArray.count == 0)
                [selfController.collectionView addSubview:_placeHolderLabel];
                 return ;
         }
         //清空数组,防止每次显示页面时,数组内容累加
         [_recommendArray removeAllObjects];
         //JSON解析
         NSDictionary * dicSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSDictionary * dicData = dicSource[@"data"];
         NSArray * arrayReturnData = dicData[@"returnData"];
         
         for (NSDictionary * boutiqueDic in arrayReturnData)
         {
             Boutique * boutique = [[Boutique alloc] init];
             [boutique setValuesForKeysWithDictionary:boutiqueDic];
             [_recommendArray addObject:boutique];
         }
         
        if (arrayReturnData.count == 0)
            [selfController.collectionView addSubview:_placeHolderLabel];
        else
            [_placeHolderLabel removeFromSuperview];
         
//        NSLog(@"%@",_recommendArray);
         // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
         [selfController.collectionView headerEndRefreshing];
         //到顶部刷新
         [selfController.collectionView reloadData];
     }];
}
//分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//集合视图的sections为0就是0,不会默认为1
}
//items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recommendArray.count;
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BoutiqueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"boutiqueCell" forIndexPath:indexPath];
    //    设置图片圆角
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 10;
    cell.boutique = _recommendArray[indexPath.item];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    取model
    Boutique * boutique = _recommendArray[indexPath.item];
    //    拼网址
    __block NSString * urlString = [NSString stringWithFormat:comicUrl,boutique.comic_id];
    
    ContentsTableViewController * contents = [[ContentsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    //    设导航
    UINavigationController * NC = [[UINavigationController alloc] initWithRootViewController:contents];
    //    属性传值
    contents.urlString = urlString;
    contents.name = boutique.name;
    //    特效
    NC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    推出
    [self presentViewController:NC animated:YES completion:nil];
    
}
//抽屉按钮
-(void)setupLeftMenuButton
{
    
    UIBarButtonItem * leftBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"drawerICO"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    leftBI.tintColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    //    添加
    self.navigationItem.leftBarButtonItem = leftBI;
}
//抽屉按钮动作
-(void)leftDrawerButtonPress:(id)sender
{
    //开关左抽屉
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
//推出搜索
-(void)searchComic
{
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    UINavigationController * searchNC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [searchNC.navigationBar setTranslucent:NO];
    [searchNC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:searchNC animated:YES completion:nil];
}

@end
