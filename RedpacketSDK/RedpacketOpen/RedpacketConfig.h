//
//  RedpacketConfig1.h
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/10/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RedpacketViewControl.h"


/** 发送红包消息回调*/
typedef void(^RedpacketSendPacketBlock)(NSDictionary *dict);
/** 抢红包成功回调*/
typedef void(^RedpacketGrabPacketBlock)(NSDictionary *dict);


@class RedpacketUserInfo;

@interface RedpacketConfig : NSObject

+ (RedpacketConfig *)sharedConfig;


- (void)configViewControlWithCurrentController:(UIViewController *)controller
                           viewControlDeleagte:(id <RedpacketViewControlDelegate> )delegate
                           currentConversation:(RedpacketUserInfo *)info
                            redpacketSendBlock:(RedpacketSendPacketBlock)sendBlock
                         andRedpacketGrabBlock:(RedpacketGrabPacketBlock)grabBlock;

- (void)changeReceiverInfo:(RedpacketUserInfo *)info;

@end


@interface RedpacketConfig (RedpacketControllers)


/** 展示单聊发红包页面*/
- (void)presentRedpacketSendViewController;

/** 展示单聊小额随机发红包页面*/
- (void)presentRandRedpacketSendViewController;

/** 展示转账页面, 传入接收转账的用户信息*/
- (void)presentTransferViewController:(RedpacketUserInfo *)userInfo;

/** 展示群聊发红包页面, 传入当前群组的用户数量*/
- (void)presentGroupRedpacketSendViewControllerWithMemeberCount:(NSInteger)count;

/** 展示群聊定向发红包页面, 传入当前群组的用户数量*/
- (void)presentMemberGroupRedpacketViewControllerWithMemberCount:(NSInteger)count;

/** 展示零钱页面*/
- (void)presentChangeViewControllerInController:(UIViewController *)viewController;

/** 抢红包页面*/
- (void)grabRedpacket:(NSDictionary *)redpacketDic;

- (UITableViewCell *)cellForRedpacketMessageDict:(NSDictionary *)dict;

- (CGFloat)heightForRedpacketMessageDict:(NSDictionary *)dict;

@end
