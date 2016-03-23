//
//  AppDelegate.m
//  Project_A
//
//  Created by 付正 on 15/5/28.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    
    if (canShow)
    {
        NewFeatureModel * page1 = [NewFeatureModel model:[UIImage imageNamed:@"1"]];
        NewFeatureModel * page2 = [NewFeatureModel model:[UIImage imageNamed:@"2"]];
        NewFeatureModel * page3 = [NewFeatureModel model:[UIImage imageNamed:@"3"]];
        NewFeatureModel * page4 = [NewFeatureModel model:[UIImage imageNamed:@"4"]];
        _window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[page1,page2,page3,page4] enterBlock:^
                                      {
                                          [self enterRoot];
                                      }];
    }
    else
    {
        [self enterRoot];
    }
    [self setReachability];
    
    [self.window makeKeyAndVisible];
    return YES;
    
}
-(void)enterRoot
{
    RootViewController * rootVC = [[RootViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootVC;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRippleEffect subType:TransitionSubtypesFromTop curve:TransitionCurveLinear duration:1.0f];
}
//注册通知
-(void)setReachability
{
    _reachability = [Reachability reachabilityForInternetConnection];
    [self examStatus];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(examStatus) name:kReachabilityChangedNotification object:nil];
    [_reachability startNotifier];
}

//验证网络
-(void)examStatus
{
    switch (_reachability.currentReachabilityStatus)
    {
        case NotReachable:
        {
            //            NSLog(@"网络不可用");
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:@"请检查网络" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"设置", nil];
            [alert show];
        }
            break;
        case ReachableViaWWAN:
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"当前为3g/4g链接" message:@"漫画程序极耗流量,建议在WIFI下运行,土豪无视此信息" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"设置", nil];
            [alert show];
            //            NSLog(@"当前为3g网络");
        }
            break;
        case ReachableViaWiFi:
        {
            //            NSLog(@"当前为wifi网络");
        }
            break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    //    清除缓存
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    //    清除混存
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end
