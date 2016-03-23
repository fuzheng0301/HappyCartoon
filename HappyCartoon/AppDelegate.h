//
//  AppDelegate.h
//  Project_A
//
//  Created by 付正 on 15/5/28.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) Reachability * reachability;

@end

