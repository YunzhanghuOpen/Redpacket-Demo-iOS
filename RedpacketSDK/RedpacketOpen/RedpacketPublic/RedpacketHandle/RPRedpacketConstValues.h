//
//  RPRedpacketConstValues_v.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 207/5/6.
//  Copyright © 207年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//  此常量值仅用作iOS和Android两边的数据传输， 如果不合适，开发者可以自定义

// 是否是红包消息
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSign;
// 是否是红包回执消息
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketTakenMessageSign;
// 红包ID
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketID;
// 红包类型 (
UIKIT_EXTERN NSString *const RedpacketKeyRedapcketType;
// 红包的发送方ID
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSenderId;
// 红包的发送方
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSenderNickname;
// 红包的接收方ID
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketReceiverId;
// 红包的接收方
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketReceiverNickname;
// 定向红包的接收者id
UIKIT_EXTERN NSString *const RedpacketKeyRedapcketToReceiver;
// 红包的名字（例如：云红包）
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketOrgName;
// 红包的祝福语
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketGreeting;
// 红包回执消息需要带上红包所在的群组ID
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketCmdToGroup;

//------------------------------
// 红包类型
//------------------------------

//  定向红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketMember;
//  小额随机红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketConst;
//  群平均红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketGroupAvg;
//  群随机红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketGroupRand;
//  广告红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketAdvertisement;
//  系统红包
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSystem;

