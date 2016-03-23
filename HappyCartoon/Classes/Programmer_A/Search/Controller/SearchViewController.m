//
//  SearchViewController.m
//  Project_A
//
//  Created by 付正 on 15/6/4.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "SearchViewController.h"
#import "CartoonListsDetail.h"
#import "CartoonListTableViewCell.h"
#import "ContentsTableViewController.h"

#define searchUrl @"http://app.u17.com/v3/app/android/phone/search/rslist?q=%@"
#define comicUrl @"http://app.u17.com/v3/app/android/phone/comic/detail?comicid=%@"
@interface SearchViewController ()
{
    UITapGestureRecognizer * _tapGR;
}
@property (strong,nonatomic)NSMutableArray * comicArray;
@property (strong,nonatomic)NSNumber * comicNum;
@end

@implementation SearchViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    
    //添加背景
    UIImageView *searchimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *searchimg = [UIImage imageNamed:@"109.png"];
    [searchimgView setImage:searchimg];
    self.tableView .backgroundView= searchimgView;
    
    [super viewDidLoad];
    self.comicArray = [NSMutableArray array];
    if (!_placeHolderLabel) {
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 44)];
    }
    _placeHolderLabel.text = @"网络异常,请检查网络后重新搜索";
    [self setTablerView];
}
-(void)setTablerView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"CartoonListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cartoonListCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"搜索";
    //    加导航左键
    UIBarButtonItem *leftBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRecomment)];
    leftBI.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = leftBI;
    //    加手势
    _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchResignFirstResponder:)];
    _tapGR.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:_tapGR];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self beginSearch];
}
- (IBAction)searchButton:(id)sender
{
    [self beginSearch];
}
-(void)beginSearch
{
    //    取消第一响应者
    [self.searchBar resignFirstResponder];
    __unsafe_unretained SearchViewController * selfController = self;
    
    NSString * urlString = [self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:searchUrl,urlString]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (nil == data)
        {
            //            NSLog(@"请求数据失败");
            //            [_comicArray addObject:@"未找到结果"];
            [selfController.tableView addSubview:_placeHolderLabel];
            return ;
        }
        [_comicArray removeAllObjects];
        NSDictionary * dicSourch = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dicData = dicSourch[@"data"];
        NSDictionary * dicReturnData = dicData[@"returnData"];
        //        NSLog(@"%@",dicReturnData[@"comicNum"]);
        _comicNum = dicReturnData[@"comicNum"];
        //        如果搜索结果为空
        if ([_comicNum intValue] == 0)
        {
            [_comicArray addObject:@"未找到结果"];
            //            未找到搜索结果,空白处需要单击触发取消第一相应
            [selfController.tableView addGestureRecognizer:_tapGR];
            [_placeHolderLabel removeFromSuperview];
        }
        else//如果搜索到结果
        {
            NSArray * comicListArray = dicReturnData[@"comicList"];
            for (NSDictionary * dicComic in comicListArray)
            {
                CartoonListsDetail * detail = [[CartoonListsDetail alloc] init];
                [detail setValuesForKeysWithDictionary:dicComic];
                [_comicArray addObject:detail];
            }
            //            找到搜索结果需要移除手势,否则会截取对cell的点击事件,造成cell不能被点击
            [selfController.tableView removeGestureRecognizer:_tapGR];
            
        }
        //        重载
        [selfController.tableView reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comicArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_comicNum intValue] == 0)//如果搜索结果为空
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = _comicArray[0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        //cell的背景色
        cell.backgroundColor = [UIColor colorWithRed:0.793 green:0.777 blue:0.676 alpha:1.000];
        
        return cell;
    }
    else//如果搜索结果不为空
    {
        CartoonListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cartoonListCell" forIndexPath:indexPath];
        cell.detail = _comicArray[indexPath.row];
        //    设置图片圆角
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.cornerRadius = 10;
        //cell的背景图片
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
        UIImage *img = [UIImage imageNamed:@"111.png"];
        [imgView setImage:img];
        cell.backgroundView = imgView;
        
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_comicNum intValue] == 0)
        return 44;
    else
        return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_comicNum intValue] == 0)
    {
        return ;
    }
    //    取model
    CartoonListsDetail * detail =_comicArray[indexPath.row];
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
//出现新cell时,取消第一响应
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    当cell变化时,取消第一响应者
    if ([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
}
//模态返回
-(void)backToRecomment
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableView为空时,单击取消第一响应
-(void)searchResignFirstResponder:(UITapGestureRecognizer*)tapGR
{
    [self.searchBar resignFirstResponder];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _placeHolderLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 44);
}
@end
