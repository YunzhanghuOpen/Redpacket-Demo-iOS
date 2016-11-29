//
//  AppDelegate.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 16/9/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "RedpacketConfig.h"
#import "RedpacketFucListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
#pragma mark - 第一步初始化SDK
    [RedpacketConfig sharedConfig];
    
#pragma mark - END
    
    RedpacketFucListViewController *listVC = [[RedpacketFucListViewController alloc] initWithNibName:NSStringFromClass([RedpacketFucListViewController class]) bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listVC];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
