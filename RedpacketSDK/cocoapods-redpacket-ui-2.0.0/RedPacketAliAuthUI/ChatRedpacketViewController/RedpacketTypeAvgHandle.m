//
//  RedpacketTypeAvgHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeAvgHandle.h"

@implementation RedpacketTypeAvgHandle

- (void)getRedpacketDetail {
    [super getRedpacketDetail];
    rpWeakSelf;
    BOOL isReceive = [weakSelf.messageModel.receiveMoney floatValue] > 0;
    switch (weakSelf.messageModel.statusType) {
        case RPRedpacketStatusTypeCanGrab: {
            if (weakSelf.messageModel.isSender){
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            } else if (isReceive) {
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            } else {
                [weakSelf setingPacketViewWith:weakSelf.messageModel
                                 boxStatusType:RedpacketBoxStatusTypeRobbing
                              closeButtonBlock:^(RPRedpacketPreView *packetView) {
                                  [weakSelf removeRedPacketView];
                } submitButtonBlock:^(RedpacketBoxStatusType boxStatusType, RPRedpacketPreView *packetView) {
                    [weakSelf.delegate sendGrabRedpacketRequest:weakSelf.messageModel];
                }];
            }
            break;
        }
        case RPRedpacketStatusTypeGrabFinish: {
            if (weakSelf.messageModel.isSender){
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            } else if (isReceive) {
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
            }else {
                [weakSelf setingPacketViewWith:weakSelf.messageModel
                                 boxStatusType:RedpacketBoxStatusTypeAvgRobbed
                              closeButtonBlock:^(RPRedpacketPreView *packetView){
                                  [weakSelf removeRedPacketView];
                           } submitButtonBlock:nil];
            }
            break;
        }
        case RPRedpacketStatusTypeOutDate: {
            [weakSelf setingPacketViewWith:weakSelf.messageModel
                             boxStatusType:RedpacketBoxStatusTypeOverdue
                          closeButtonBlock:^(RPRedpacketPreView *packetView) {
                              [weakSelf removeRedPacketView];
                       } submitButtonBlock:nil];
            
        }
            break;
    }
}
@end
