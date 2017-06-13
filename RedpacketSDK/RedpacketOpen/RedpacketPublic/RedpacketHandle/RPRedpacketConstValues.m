//
//  RPRedpacketConstValues_v.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 207/5/6.
//  Copyright © 207年 Mr.Yang. All rights reserved.
//

#import "RPRedpacketConstValues.h"


/**
 *  红包被打开的消息
 */
NSString *const RedpacketKeyRedpacketTakenMessageSign  = @"is_open_money_msg";

/**
 *  收到红包消息
 */
NSString *const RedpacketKeyRedpacketSign              = @"is_money_msg";

/**
 *  红包ID
 */
NSString *const RedpacketKeyRedpacketID                = @"ID";

/**
 *  红包的Type类型
 */
NSString *const RedpacketKeyRedapcketType               = @"money_type_special";

/**
 *  红包的发送方ID
 */
NSString *const RedpacketKeyRedpacketSenderId          = @"money_sender_id";

/**
 *  红包的发送方
 */
NSString *const RedpacketKeyRedpacketSenderNickname    = @"money_sender";

/**
 *  红包的接收方ID
 */
NSString *const RedpacketKeyRedpacketReceiverId        = @"money_receiver_id";

/**
 *  红包的接收方
 */
NSString *const RedpacketKeyRedpacketReceiverNickname  = @"money_receiver";

/**
 * 红包的名字 **红包
 */
NSString *const RedpacketKeyRedpacketOrgName           = @"money_sponsor_name";

/**
 *  红包的祝福语
 */
NSString *const RedpacketKeyRedpacketGreeting          = @"money_greeting";

/**
 *  红包回执消息需要带上红包所在的群组ID
 */
NSString *const RedpacketKeyRedpacketCmdToGroup        = @"money_from_group_id";


//------------------------------
// 红包类型
//------------------------------

//  定向红包
NSString *const RedpacketKeyRedpacketMember             = @"member";

//  小额随机红包
NSString *const RedpacketKeyRedpacketConst              = @"const";

//  群平均红包
NSString *const RedpacketKeyRedpacketGroupAvg           = @"avg";
//  群随机红包
NSString *const RedpacketKeyRedpacketGroupRand          = @"rand";
//  广告红包
NSString *const RedpacketKeyRedpacketAdvertisement      = @"advertisement";
//  系统红包
NSString *const RedpacketKeyRedpacketSystem             = @"randpri";

