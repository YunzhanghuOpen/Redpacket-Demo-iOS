//
//  AppDelegate+Redpacket.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/7/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

/**
 *  处理支付宝支付 和 微信支付
 */

@interface AppDelegate (Redpacket) <WXApiDelegate>

//  从后台直接唤起App时，如果App正在调用微信或者支付宝则取消支付
- (void)redpacket_applicationDidBecomeActive:(UIApplication *)application;

// NOTE: iOS9.0之前使用的API接口
- (BOOL)redpacket_application:(UIApplication *)application
                      openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
                   annotation:(id)annotation;

// NOTE: iOS9.0之后使用新的API接口
- (BOOL)redpacket_application:(UIApplication *)app
                      openURL:(NSURL *)url
                      options:(NSDictionary<NSString*, id> *)options;

@end
