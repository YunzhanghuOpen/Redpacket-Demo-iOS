//
//  AnalysisRedpacketModel.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yan on 207/5/.
//  Copyright © 207年 Mr.Yan. All rights reserved.
//

#import "AnalysisRedpacketModel.h"
#import "RPRedpacketConstValues.h"


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
