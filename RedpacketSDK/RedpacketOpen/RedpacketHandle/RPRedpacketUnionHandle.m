//
//  RPRedpacketUnionHandle.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 207/5/9.
//  Copyright © 207年 Mr.Yang. All rights reserved.
//

#import "RPRedpacketUnionHandle.h"
#import "RPRedpacketConstValues.h"

#define IGNORE_PUSH_MESSAGE  @"em_ignore_notification"

@implementation RPRedpacketUnionHandle

//  生成通道中传输的Dict
+ (NSDictionary *)dictWithRedpacketModel:(RPRedpacketModel *)model
                            isACKMessage:(BOOL)isAckMessage
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:model.redpacketID forKey:RedpacketKeyRedpacketID];
    
    //  发送者ID
    [dic setValue:model.sender.userID forKey:RedpacketKeyRedpacketSenderId];
    //  发送者昵称
    [dic setValue:model.sender.userName forKey:RedpacketKeyRedpacketSenderNickname];
    
    //  接收者ID
    [dic setValue:model.receiver.userID forKey:RedpacketKeyRedpacketReceiverId];
    //  接收者昵称
    [dic setValue:model.receiver.userName forKey:RedpacketKeyRedpacketReceiverNickname];
    
    //  除了单聊红包其它红包都是有值的
    [dic setValue:model.redpacketTypeStr forKey:RedpacketKeyRedapcketType];
    [dic setValue:model.greeting forKey:RedpacketKeyRedpacketGreeting];
    
    //  红包回执消息
    if (isAckMessage) {
        
        //  红包被抢消息
        [dic setValue:@(YES) forKey:RedpacketKeyRedpacketTakenMessageSign];
        [dic setValue:model.groupID forKey:RedpacketKeyRedpacketCmdToGroup];
        
    }else {
        
        //  红包消息
        [dic setValue:@(YES) forKey:RedpacketKeyRedpacketSign];
        
    }
    
    return dic;
}

//  IM通道中传入的Dict
+ (RPRedpacketModel *)modelWithChannelRedpacketDic:(NSDictionary *)redpacketDic
                                         andSender:(RPUserInfo *)sender
{
    NSString *redpacketID = [redpacketDic objectForKey:RedpacketKeyRedpacketID];
    NSString *redpacketType = [redpacketDic objectForKey:RedpacketKeyRedapcketType];
    
    //  如果为空则消息体有问题
    if (redpacketID.length == 0) {
    
        return nil;
        
    }
    
    RPRedpacketModel *model = [RPRedpacketModel modelWithRedpacketID:redpacketID
                                                       redpacketType:redpacketType
                                                  andRedpacketSender:sender];
    
    return model;
}


@end
