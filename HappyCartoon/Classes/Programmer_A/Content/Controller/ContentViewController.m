//
//  ContentViewController.m
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//
#import "ContentViewController.h"
#import "CartoonContent.h"
#import "UIImageView+WebCache.h"

#define chapterUrl @"http://app.u17.com/v3/app/android/phone/comic/chapter?chapter_id=%@"
#define Width (self.view.frame.size.width-10)
@interface ContentViewController ()
@property (strong, nonatomic) NSMutableArray * contentArray;
@property (strong, nonatomic) NSMutableArray * imageViewArray;
@property (strong, nonatomic) UIView * contentView;
@end

@implementation ContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    初始化属性
    self.view.backgroundColor = [UIColor grayColor];
    self.contentArray = [NSMutableArray array];
    self.imageViewArray = [NSMutableArray array];
    _lightSlider.value = [UIScreen mainScreen].brightness;
    _progressSlider.value = _cartoonScrollView.contentOffset.y;
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    if (!_placeHolderLabel)
        self.placeHolderLabel = [[PlaceHolderLabel alloc] initWithFrame:CGRectMake(0, rect.size.height / 2.0 - 22, rect.size.width, 44)];
    _placeHolderLabel.textColor = [UIColor whiteColor];
    _placeHolderLabel.text = @"数据异常,图片暂时无法显示";
    
    //     初始化导航控制器
    [self initNavigation];
    //    添加双击手势
    [self setDoubleTapGP];
}
//布局scrollView
-(void)loadScrollView
{
    //    放大和缩小都在contentView上进行
    //    将_cartoonScrollView清空
    [_contentView removeFromSuperview];
    _contentView = nil;
    //    初始_contentView
    self.contentView = [[UIView alloc] initWithFrame:self.cartoonScrollView.frame];
    //    添加
    [self.cartoonScrollView addSubview:_contentView];
    //    Set Delegate
    self.cartoonScrollView.delegate = self;
    //    背景色
    self.cartoonScrollView.backgroundColor = [UIColor grayColor];
    //    调用写入漫画方法
    [self setScrollViewContentSizeAndImageView];
    
    //    设置ContentView的frame
    CGRect frame = self.contentView.frame;
    frame.size = self.cartoonScrollView.contentSize;
    self.contentView.frame = frame;
    //    设置缩放Range
    self.cartoonScrollView.minimumZoomScale = 1;
    self.cartoonScrollView.maximumZoomScale = 3.0;
    
}
//布局scroll尺寸
-(void)setScrollViewContentSizeAndImageView
{
    //ScrollView的总Height
    CGFloat scrollHeight = 0.0;
    
    for (CartoonContent * content in _contentArray)
    {
        //图片等比例缩放高度
        CGFloat heightTemp = Width * [content.height intValue] / [content.width intValue];
        //创建ImageView
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, scrollHeight, Width , heightTemp )];
        //初始化并添加大菊花
        __block MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:imageView];
        [imageView addSubview:HUD];
        HUD.delegate = self;
        HUD.animationType = MBProgressHUDAnimationZoom;
        HUD.labelText = @"拼命加载中";
        [HUD show:YES];
        
        //异步解析图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:content.location] placeholderImage:[UIImage imageNamed:@"backImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             //             隐藏大菊花
             [HUD hide:YES];
         }];
        //        清除缓存
        [self clearCache];
        //图片添加到contentView上
        [_contentView addSubview:imageView];
        //scrollView的size
        scrollHeight = scrollHeight + heightTemp +10;
    }
    //设置contentSize
    self.cartoonScrollView.contentSize = CGSizeMake(Width, scrollHeight);
    
    if (_contentArray.count == 0) {
        if (_placeHolderLabel.superview == nil) {
            [self.view addSubview:_placeHolderLabel];
        }
    }
    else
        [_placeHolderLabel removeFromSuperview];
}
-(void)initNavigation
{
    //    设置导航栏属性
    self.titleLabel.text = _NCTitle;
    [self.dismissButton addTarget:self action:@selector(backToParentController) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated
{
    //    解析
    [self JSON];
}
//JSON
-(void)JSON
{
    __unsafe_unretained ContentViewController * selfController = self;
    //    _urlString当前章节内容的链接,可变
    NSURL * url = [NSURL URLWithString:_urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil) {
             //             NSLog(@"请求数据失败");
             //             断网保护
             [selfController loadScrollView];
             return ;
         }
         //         清空moedl数组
         [_contentArray removeAllObjects];
         NSDictionary * dicSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         NSDictionary * dicData = dicSource[@"data"];
         
         NSArray * returnData = dicData[@"returnData"];
         //         添加model
         for (NSDictionary * contentDic in returnData)
         {
             CartoonContent * cartoon = [[CartoonContent alloc] init];
             [cartoon setValuesForKeysWithDictionary:contentDic];
             [_contentArray addObject:cartoon];
         }
         //         加载_cartoonScrollView的漫画内容
         [selfController loadScrollView];
     }];
}
//模态返回
-(void)backToParentController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//设置缩放对象
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}
//设置单击,双击手势
-(void)setDoubleTapGP
{
    //    设置点击手势并添加到_contentView
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToOrignFrame)];
    //    点击次数
    doubleTap.numberOfTapsRequired = 2;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewControl:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}
//双击手势方法
-(void)backToOrignFrame
{
    //设置动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //    如果缩放为1,设置为2,如果缩放不为1,设置为1
    if (self.cartoonScrollView.zoomScale == 1)
    {
        self.cartoonScrollView.zoomScale = 2;
    }
    else
    {
        self.cartoonScrollView.zoomScale = 1;
    }
    [UIView commitAnimations];
    [self.view sendSubviewToBack:_headerView];
    [self.view sendSubviewToBack:_menuView];
}
//左清扫下一章
- (IBAction)leftSwipe:(UISwipeGestureRecognizer *)sender
{
    //    通过block互殴去
    ChapterList * list = _nextChapter();
    [self changeChapterWithList:list Context:@"已到最后一章"];
}
//右清扫上一章
- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender
{
    ChapterList * list = _lastChapter();
    [self changeChapterWithList:list Context:@"已到第一章"];
}
//重新解析数据
-(void)changeChapterWithList:(ChapterList*)list Context:(NSString*)context
{
    //    如果新章节的title和当前章节的list.name一样,说明已到第一章或最后一章
    if ([_NCTitle isEqualToString:list.name])
    {
        //        alert提示
        [self showAlertWithTitle:context];
        return ;
    }
    
    //    清理缓存,
    [self clearCache];
    //    停止未完成下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    //    拼接url
    _urlString = [NSString stringWithFormat:chapterUrl,list.chapter_id];
    //    赋值_NCTitle,用来判断是否是重复章节
    _NCTitle = list.name;
    self.titleLabel.text = _NCTitle;
    //    解析
    [self JSON];
    //    当推出其他章节时,返回到漫画首页
    [_cartoonScrollView setContentOffset:CGPointMake(0, 0)];
    //    当改变章节时,进度指示器指示当前值
    _progressSlider.value = _cartoonScrollView.contentOffset.y;
}
//提示越界
-(void)showAlertWithTitle:(NSString*)title
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    //    定义并添加确定按钮
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    //    模态退出alert
    [self presentViewController:alert animated:nil completion:nil];
    
}
//调节屏幕亮度
- (IBAction)changeBachgroundLight:(id)sender
{
    [[UIScreen mainScreen]setBrightness:_lightSlider.value];
}
//调节阅读进度,scrollView的偏移量
- (IBAction)changeProgress:(id)sender
{
    _cartoonScrollView.contentOffset =  CGPointMake(0,_progressSlider.value * (_cartoonScrollView.contentSize.height - self.view.frame.size.height));
}

//控制导航和菜单显示
-(void)menuViewControl:(UITapGestureRecognizer*)singleTap
{
    
    NSArray * array = self.view.subviews;
    if (_menuView == array[0])
    {
        [self.view bringSubviewToFront:_headerView];
        [self.view bringSubviewToFront:_menuView];
    }
    else
    {
        [self.view sendSubviewToBack:_headerView];
        [self.view sendSubviewToBack:_menuView];
    }
}
//scrollView滑动过程中,progressSlider的值时刻跟随变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _progressSlider.value = _cartoonScrollView.contentOffset.y / (_cartoonScrollView.contentSize.height - self.view.frame.size.height);
}
//旋转自适应
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    _placeHolderLabel.frame = CGRectMake(0, rect.size.height / 2.0 - 22, rect.size.width, 44);
    self.cartoonScrollView.zoomScale = 1.0;
    [self loadScrollView];
}

-(void)didReceiveMemoryWarning
{
    [self clearCache];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self clearCache];
}
-(void)clearCache
{
    //    清除缓存
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    //    清除混存
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

@end
