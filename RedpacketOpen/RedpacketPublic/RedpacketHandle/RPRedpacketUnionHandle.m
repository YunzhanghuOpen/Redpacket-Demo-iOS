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

@implementation RPUser


@end


@implementation AnalysisRedpacketModel

+ (MessageCellType)messageCellTypeWithDict:(NSDictionary *)dict
{
    if ([dict objectForKey:RedpacketKeyRedpacketSign] ||
        [dict objectForKey:RedpacketKeyRedpacketSign]) {
        
        return MessageCellTypeRedpaket;
        
    } else if ([dict objectForKey:RedpacketKeyRedpacketTakenMessageSign] ||
               [dict objectForKey:RedpacketKeyRedpacketTakenMessageSign]) {
        
        return MessageCellTypeRedpaketTaken;
        
    }
    
    return MessageCellTypeUnknown;
}

+ (AnalysisRedpacketModel *)analysisRedpacketWithDict:(NSDictionary *)dict
                                          andIsSender:(BOOL)isSender
{
    MessageCellType type = [self messageCellTypeWithDict:dict];
    if (type == MessageCellTypeUnknown) {
        
        return nil;
        
    }
    
    AnalysisRedpacketModel *analysisModel = [AnalysisRedpacketModel new];
    
    [analysisModel configWithModel:dict
                          isSender:isSender
                    andMessageType:type];
    
    return analysisModel;
}

- (void)configWithModel:(NSDictionary *)dict
               isSender:(BOOL)isSender
         andMessageType:(MessageCellType)messageType
{
    _type = messageType;
    
    _isSender = isSender;
    _redpacketOrgName = @"云账户";
    
    _greeting = dict[RedpacketKeyRedpacketGreeting];
    
    _redpacketType = [self redpacketTypeWithString:dict[RedpacketKeyRedapcketType]];
    //  sender
    RPUser *sender = [RPUser new];
    sender.userID = dict[RedpacketKeyRedpacketSenderId];
    
    if (sender.userID.length == 0) {
        sender.userID = dict[RedpacketKeyRedpacketSenderId];
    }
    
    sender.userName = dict[RedpacketKeyRedpacketSenderNickname];
    if (sender.userName.length == 0) {
        sender.userName = dict[RedpacketKeyRedpacketSenderNickname];
    }
    
    self.sender = sender;
    
    //  receiver
    RPUser *receiver = [RPUser new];
    
    receiver.userID = dict[RedpacketKeyRedpacketReceiverId];
    if (receiver.userID.length == 0) {
        receiver.userID = dict[RedpacketKeyRedpacketReceiverId];
    }
    
    receiver.userName = dict[RedpacketKeyRedpacketReceiverNickname];
    if (receiver.userName.length == 0) {
        receiver.userName = dict[RedpacketKeyRedpacketReceiverNickname];
    }
    
    self.receiver = receiver;
}


- (RPRedpacketType)redpacketTypeWithString:(NSString *)type
{
    RPRedpacketType rpType = 0;
    
    if ([type isEqualToString:RedpacketKeyRedpacketMember]) {
        
        rpType = RPRedpacketTypeGoupMember;
        
    }else if ([type isEqualToString: RedpacketKeyRedpacketConst]) {
        
        rpType = RPRedpacketTypeAmount;
        
    }else if ([type isEqualToString: RedpacketKeyRedpacketGroupRand]) {
        
        rpType = RPRedpacketTypeGroupRand;
        
    }else if ([type isEqualToString: RedpacketKeyRedpacketGroupAvg]) {
        
        rpType = RPRedpacketTypeGroupAvg;
        
    }else if ([type isEqualToString: RedpacketKeyRedpacketAdvertisement]) {
        
        rpType = RPRedpacketTypeAdvertisement;
        
    }else if ([type isEqualToString: RedpacketKeyRedpacketSystem]) {
        
        rpType = RPRedpacketTypeSystem;
        
    }else {
        
        rpType = RPRedpacketTypeSingle;
        
    }
    
    return rpType;
}

@end

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
