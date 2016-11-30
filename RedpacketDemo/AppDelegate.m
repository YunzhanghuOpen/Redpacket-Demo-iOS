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

#ifdef REDPACKET_AVALABLE

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self redpacket_applicationDidBecomeActive:application];
}

// NOTE: iOS9.0之前使用的API接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    [self redpacket_application:application
                        openURL:url
              sourceApplication:sourceApplication
                     annotation:annotation];
    
    return YES;
}

//// NOTE: iOS9.0之后使用新的API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    [self redpacket_application:app
                        openURL:url
                        options:options];
    
    return YES;
}

#endif

@end
