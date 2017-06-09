//
//  RedpacketTypeAmountHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 2016/11/4.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeAmountHandle.h"

@implementation RedpacketTypeAmountHandle

- (void)getRedpacketDetail {
    [super getRedpacketDetail];
    //  如果红包状态可以抢， 且不是自己发送的红包
    if (self.messageModel.statusType == RPRedpacketStatusTypeCanGrab && !self.messageModel.isSender) {
        //  抢红包
        [self.delegate sendGrabRedpacketRequest:self.messageModel];
    }else {
        //  显示红包状态界面
        [self setingPacketViewWith:self.messageModel
                     boxStatusType:RedpacketBoxStatusTypeReceiveAmount
                  closeButtonBlock:^(RPRedpacketPreView *packetView){
                      [self removeRedPacketView];
               } submitButtonBlock:nil];
    }
}

@end
