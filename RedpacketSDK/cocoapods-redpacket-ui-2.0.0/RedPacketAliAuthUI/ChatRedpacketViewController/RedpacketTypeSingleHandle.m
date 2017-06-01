//
//  RedpacketTypeSingleHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeSingleHandle.h"

@implementation RedpacketTypeSingleHandle
- (void)getRedpacketDetail {
    [super getRedpacketDetail];

    rpWeakSelf;
    BOOL isReceive = [weakSelf.messageModel.receiveMoney floatValue] > 0;
    switch (weakSelf.messageModel.statusType) {
        case RPRedpacketStatusTypeCanGrab: {
            if (weakSelf.messageModel.isSender || isReceive) { //  自己发送的 或者 自己已领取过的红包
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            } else { //  展示抢红包页面
                [weakSelf setingPacketViewWith:weakSelf.messageModel
                                 boxStatusType:RedpacketBoxStatusTypePoint
                              closeButtonBlock:^(RPRedpacketPreView *packetView) {
                                  [weakSelf removeRedPacketView];
                           } submitButtonBlock:^(RedpacketBoxStatusType boxStatusType, RPRedpacketPreView *packetView) {
                               [weakSelf.delegate sendGrabRedpacketRequest:weakSelf.messageModel];
                }];
            }
            break;
        }
        case RPRedpacketStatusTypeGrabFinish: {
            if (weakSelf.messageModel.isSender || isReceive) {
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            } else {
                [weakSelf.delegate sendGrabRedpacketRequest:weakSelf.messageModel];
            }
            break;
        }
        case RPRedpacketStatusTypeOutDate: {
            if (weakSelf.messageModel.isSender) {
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            }else{
                [weakSelf setingPacketViewWith:weakSelf.messageModel
                                 boxStatusType:RedpacketBoxStatusTypeOverdue
                              closeButtonBlock:^(RPRedpacketPreView *packetView) {
                                  [weakSelf removeRedPacketView];
                } submitButtonBlock:nil];
            }
            break;
        }
    }
}

@end
