//
//  AppDelegate+Redpacket.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/7/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "AppDelegate+Redpacket.h"
#import "RedpacketOpenConst.h"
#import <AlipaySDK/AlipaySDK.h>

#define RedpacketWechatSuccess  = 1
#define RedpacketWechatFaile = 0

@implementation AppDelegate (Redpacket) 

- (void)redpacket_applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redpacket_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    /**
     *  取消支付
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketCancelPayNotifaction object:nil];
}

// NOTE: iOS9.0之前使用的API接口
- (BOOL)redpacket_application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if ([url.host isEqualToString:@"safepay"]) {
        /**
         *  支付宝钱包
         */
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketAlipayNotifaction object:resultDic];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        /**
         *  微信支付
         */
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

// NOTE: iOS9.0之后使用新的API接口
- (BOOL)redpacket_application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        /**
         *  支付宝钱包
         */
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketAlipayNotifaction object:resultDic];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        /**
         *  微信支付
         */
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

/**
 *  微信支付回
 */
-(void)onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketWechatPayNotifaction object:resp];
                break;
            default:
                //微信支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketCancelPayNotifaction object:nil];
                break;
        }
    }
}

@end
