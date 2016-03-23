//
//  HistoryListTableViewController.m
//  Project_A
//
//  Created by 付正 on 15/6/8.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "HistoryListTableViewController.h"
#import "ContentViewController.h"
#import "ContentsHeaderCell.h"
#import "ChapterList.h"
#import "Comic.h"
#import "PlaceHolderLabel.h"
#define chapterUrl @"http://app.u17.com/v3/app/android/phone/comic/chapter?chapter_id=%@"

@interface HistoryListTableViewController ()

@property (strong, nonatomic) NSMutableArray * chapterListArray;
@property (strong, nonatomic) Comic * comic;
@property (assign, nonatomic) CGFloat headerCellHeight;
@property (assign, nonatomic) NSInteger currentChapter;
@property (strong, nonatomic) NSMutableArray *nameArray;
@property (strong, nonatomic) PlaceHolderLabel * placeHolderLabel;

@end

@implementation HistoryListTableViewController
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exitCollect"  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"collect" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"history" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加背景
    UIImageView *rankimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1100)];
    UIImage *rankimg = [UIImage imageNamed:@"109.png"];
    [rankimgView setImage:rankimg];
    self.tableView.backgroundView= rankimgView;
    
    self.tableView.tableFooterView = [[UIView alloc] init];//占位,去掉目录界面的空cell
    
    self.chapterListArray = [NSMutableArray array];
    self.comic = [[Comic alloc] init];
    
    //    初始化_headerCellHeight的高度
    self.headerCellHeight = 200;
    
    //    注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ContentsHeaderCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
    
    [self initNavigation];
    
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [self loadData];
}
//初始化导航栏
-(void)initNavigation
{
    self.navigationItem.title = @"漫画介绍";
    UIBarButtonItem *leftBI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParentController)];
    leftBI.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = leftBI;
}

-(void)loadData
{
    
    NSData *data = [[DBmanger sharedInstance]selectHistoryNewsByUrl:_name];
    //存储中间变量
    _dataCommon = data;
    //解析data
    NSDictionary * dicSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * dicData = dicSource[@"data"];
    NSDictionary * dicReturnData = dicData[@"returnData"];
    
    //        设置简介model
    NSDictionary * dicComic = dicReturnData[@"comic"];
    [self.comic setValuesForKeysWithDictionary:dicComic];
    
    NSArray * chapterListArray = dicReturnData[@"chapter_list"];
    for (NSDictionary * listDic in chapterListArray)
    {
        ChapterList * list = [[ChapterList alloc] init];
        [list setValuesForKeysWithDictionary:listDic];
        [_chapterListArray addObject:list];
    }
    if (chapterListArray.count == 0)
    {
        if (_placeHolderLabel.superview == nil)
        {
            [self.tableView addSubview:_placeHolderLabel];
        }
    }
    else
        [_placeHolderLabel removeFromSuperview];
}

//收藏功能实现
-(void)viewWillAppear:(BOOL)animated
{
    
    BOOL isCollect = [[DBmanger sharedInstance]isFavorite:self.name];
    if (isCollect ==  YES)
    {
        
        [self creatBarButton:@"心（收藏）.png"];
    }else
    {
        [self creatBarButton:@"心（未收藏）.png"];
    }
#pragma mark----判断历史数据库是否已经存储
    BOOL isHistory = [[DBmanger sharedInstance]isHistory:self.name];
    if (isHistory == YES) {
        [[DBmanger sharedInstance]deleteHistoryNewsByUrl:self.name];
    }
    
#pragma mark-----判断历史数据库里的数量(上限20个)
    NSMutableArray *historyArr = [[DBmanger sharedInstance]selectAllHistory];
    if (historyArr.count > 19) {
        for (HistotyModel *model in historyArr) {
            [_nameArray addObject:model.name];
        }
        NSString *name = _nameArray[0];
        [[DBmanger sharedInstance]deleteHistoryNewsByUrl:name];
    }
    
}

//创建收藏按钮
-(void)creatBarButton:(NSString *)imageName
{
    UIImage * img = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * collectButton = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(rightBtn:)];
    self.navigationItem.rightBarButtonItem = collectButton;
    
}
//
- (void)rightBtn:(UIBarButtonItem *)btn
{
    //判断是否收藏过
    BOOL isCollect = [[DBmanger sharedInstance]isFavorite:self.name];
    
    if (_dataCommon == nil) {
        //设置弹出框
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"网络不给力" preferredStyle:UIAlertControllerStyleAlert];
        //创建按钮
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
        }];
        
        //添加按钮
        [alertCtr addAction:firstAction];
        //显示弹出框
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];
    }else{
        
        //if判断
        if (isCollect == YES) {
            //如果收藏过就删除对应的内容
            [[DBmanger sharedInstance ]deleteCollectionNewsByUrl:self.name];
            //更改图标
            btn.image = [[UIImage imageNamed:@"心（未收藏）.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            //设置弹出框
            UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"取消收藏成功" preferredStyle:UIAlertControllerStyleAlert];
            //创建按钮
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
            }];
            
            //添加按钮
            [alertCtr addAction:firstAction];
            //显示弹出框
            [self presentViewController:alertCtr animated:YES completion:^{
                
            }];
            
            //发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exitCollect" object:nil];
            
        }else
        {
            //如果没有收藏过,添加数据
            [[DBmanger sharedInstance]insertCollectionNews:self.comic Contects:_dataCommon];
            //更改图标
            btn.image = [[UIImage imageNamed:@"心（收藏）.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
            //创建按钮
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
            }];
            
            //添加按钮
            [alertCtr addAction:firstAction];
            //显示弹出框
            [self presentViewController:alertCtr animated:YES completion:^{
                
            }];
            
            //发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collect" object:nil];
            
        }
    }
    
}


//区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return _chapterListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    注册了两个cell
    if (indexPath.section == 0)
    {
        ContentsHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        //        设置代理,执行代理方法
        cell.delegate = self;
        cell.comic = _comic;
        //    设置图片圆角
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.cornerRadius = 10;
        //添加适应背景图片
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
        UIImage *img = [UIImage imageNamed:@"115.png"];
        [imgView setImage:img];
        cell.backgroundView = imgView;
        return cell;
    }
    
    else
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        ChapterList *list = _chapterListArray[indexPath.row];
        
        //        拼接章节名和章节页数
        NSMutableString * text = [NSMutableString stringWithString:list.name];
        cell.textLabel.text = [text stringByAppendingString:[NSString stringWithFormat:@" (%@页)",list.image_total]];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"114.png"]];
        
        return cell;
    }
    
}

//执行点击的cell方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    点击的不是简介区
    if (indexPath.section != 0)
    {
        //        取当前章节下标,为block预备
        self.currentChapter = indexPath.row;
        //        取model
        ChapterList * list = _chapterListArray[_currentChapter];
        //        创建VC
        ContentViewController * contentVC = [[ContentViewController alloc] init];
        //        拼接urlString
        NSString * urlString = [NSString stringWithFormat:chapterUrl,list.chapter_id];
        //        属性传值
        contentVC.urlString = urlString;
        contentVC.NCTitle = list.name;
        //        调用下一章Block
        contentVC.nextChapter = ^ChapterList*()
        {
            //            章节下标加一,为下次使用服务
            _currentChapter++;
            //防止访问越界
            if (_currentChapter == _chapterListArray.count)
                _currentChapter = _chapterListArray.count-1;
            //            返回model
            return _chapterListArray[_currentChapter];
        };
        //        调用上一章Block
        contentVC.lastChapter =^ChapterList*()
        {
            //            章节下标加一,为下次使用服务
            _currentChapter--;
            //            防止访问越界
            if (_currentChapter<0)
                _currentChapter = 0;
            //            返回model
            return _chapterListArray[_currentChapter];
        };
        //        模态动画
        contentVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //        模态推出
        [self presentViewController:contentVC animated:YES completion:nil];
    }
}

-(void)backToParentController
{
    if (_dataCommon == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
#warning ----存储浏览历史
        [[DBmanger sharedInstance]insertHistoryNews:self.comic Contects:_dataCommon];
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.0];
    return myView;
}

//区高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0)
        return 10;
    else
        return 0;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.headerCellHeight;
    }
    else
        return 44;
}
//触摸cell时修改cell高度
-(void)touchDescription
{
    //    如果为默认高度,设置为自适应高度
    if (_headerCellHeight == 200)
    {
        CGFloat descriptionHeight = [self heightOfText:_comic.contectDescription];
        
        if (descriptionHeight < 43)
        {
            descriptionHeight = 43;
        }
        _headerCellHeight =  descriptionHeight + 157;
    }
    else//如果为自适应高度,还原为默认高度
    {
        _headerCellHeight = 200;
    }
    //    修改行高后重载数据
    [self.tableView reloadData];
}
//自适应高度
-(CGFloat)heightOfText:(NSString*)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(304, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height;
}

@end
