//
//  RPAliAuthPay.m
//  RedpacketLib
//
//  Created by Mr.Yang on 2016/12/19.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPAliAuthPay.h"
#import "RPRedpacketErrorCode.h"
#import "AlipaySDK.h"
#import "RPRedpacketBridge.h"
#import "UIView+YZHPrompting.h"
#import "RPAlipayAuth.h"
#import "RPRedpacketTool.h"
#import "UIAlertView+YZHAlert.h"

/*
 返回码	含义
 9000	订单支付成功
 8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000	订单支付失败
 5000	重复请求
 6001	用户中途取消
 6002	网络连接出错
 6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它	其它支付错误
 */


#define AlipayPaySuccess    9000
#define AlipayPayUserCancel 6001
#define AlipayPayResultUnKnow 8000

@interface RPAliAuthPay ()
{
    //支付的父控制器
    __weak UIViewController *_payController;
}

/**
 *  账单流水号
 */
@property (nonatomic, copy) NSString *billRef;
@property (nonatomic, copy) PaySuccessBlock paySuccessBlock;
@property (nonatomic, copy) NSString *payMoney;

@end


@implementation RPAliAuthPay

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallBack:) name:@"redpacketAlipayNotifaction" object:nil];
    }
    
    return self;
}

- (void)payMoney:(NSString *)payMoney inController:(UIViewController *)currentController andFinishBlock:(PaySuccessBlock)paySuccessBlock
{
    _payController = currentController;
    self.payMoney = payMoney;
    self.paySuccessBlock = paySuccessBlock;
    
    [self requestAlipayBillRef:payMoney
                  inController:currentController];
}

//  下单
- (void)requestAlipayBillRef:(NSString *)money
                inController:(UIViewController *)viewController
{
    [viewController.view rp_showHudWaitingView:YZHPromptTypeWating];
    
    rpWeakSelf;
    [RPRedpacketSender generateRedpacketPayOrder:money generateBlock:^(NSError *error, NSString *string) {
        
        if (error) {
            
            [viewController.view rp_removeHudInManaual];
            
            if (error.code == RedpacketUnAliAuthed) {
                
                //  没有授权
                [weakSelf showAuthAlert];
                
            }else {
                
                [weakSelf alertCancelPayMessage:@"付款失败，该红包不会被发出" withTitle:@"付款失败"];
                
            }
            
        } else {
            
            [weakSelf requestAlipayView:string withController:viewController];
            [self performSelector:@selector(delayViewController:) withObject:viewController afterDelay:2.0];
        }

    }];
}

- (void)requestAlipayView:(NSString *)orderString withController:(UIViewController *)viewController
{
    NSString *urlScheme = [[NSBundle mainBundle] bundleIdentifier];
    if (urlScheme.length == 0) {
        [self alertWithMessage:@"urlScheme为空，无法调用支付宝"];
        return;
    }
    
    rpWeakSelf;
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        RPDebug(@"支付宝支付回调BillRef:%@ Param:%@", weakSelf.billRef, resultDic);
        NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
        
        if (code == AlipayPaySuccess) {
            
            if (weakSelf.paySuccessBlock) {
                weakSelf.paySuccessBlock(weakSelf.billRef);
            }
            
        }else if (code == AlipayPayUserCancel) {
            
            [weakSelf alertCancelPayMessage:@"你已取消支付，该红包不会被发出"
                              withTitle:@"取消支付"];
            
        }else {
            
            [weakSelf alertCancelPayMessage:@"付款失败, 该红包不会被发出"
                              withTitle:@"付款失败"];
            
        }
        
    }];
}

// 支付宝App支付的回调
- (void)alipayCallBack:(NSNotification *)notifaction
{
    RPDebug(@"红包SDK通知：\n收到支付宝支付回调：%@\n 当前的控制器：%@", notifaction, self);
    
    if (self.billRef) {
        if ([notifaction.object isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[notifaction.object valueForKey:@"resultStatus"] integerValue];
            if (code == 9000) {
                //  支付成功
                if (self.paySuccessBlock) {
                    self.paySuccessBlock(self.billRef);
                }
                
            }else if (code == AlipayPayUserCancel) {
                [self alertCancelPayMessage:@"你已取消支付，该红包不会被发出"
                                  withTitle:@"取消支付"];
            }else {
                [self alertCancelPayMessage:@"付款失败, 该红包不会被发出"
                                  withTitle:@"付款失败"];
            }
            
        }else {
            self.billRef = nil;
            [_payController.view rp_removeHudInManaual];
        }
        
    }else {

        //  收到无效Alipay通知
        
    }
}

- (void)showAuthAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"需授权绑定支付宝账户"
                                                    message:@"发红包使用绑定的支付宝账号支付。"
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认授权", nil];
    
    rpWeakSelf;
    [alert setRp_completionBlock:^(UIAlertView * alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [weakSelf doAlipayAuth];
        }
    
    }];
    
    [alert show];
}

//  没有授权， 去授权
- (void)doAlipayAuth
{
    static RPAlipayAuth *staticAuth = nil;
    staticAuth = [RPAlipayAuth new];
    
    [_payController.view rp_showHudWaitingView:YZHPromptTypeWating];
    
    [staticAuth doAlipayAuth:^(BOOL isSuccess, NSString *error) {
        
        staticAuth = nil;
        [_payController.view rp_removeHudInManaual];
        
        if (isSuccess) {
            
            [self alertWithMessage:@"已成功绑定支付宝账号，以后红包收到的钱会自动入账到此支付宝账号。"];
        
        }else {
            
            [_payController.view rp_showHudErrorView:error];
            
        }
        
    }];
    
}

- (void)alertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)alertCancelPayMessage:(NSString *)message
                    withTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消支付"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    
    [alert show];
}


- (void)delayViewController:(UIViewController *)viewController
{
    [viewController.view rp_removeHudInManaual];
}

@end
