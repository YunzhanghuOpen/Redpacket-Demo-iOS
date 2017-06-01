//
//  RedpacketTypeMemberHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeMemberHandle.h"
#import "RPRedpacketManager.h"
@implementation RedpacketTypeMemberHandle
- (void)getRedpacketDetail {
    [super getRedpacketDetail];
    
    rpWeakSelf;
    
    BOOL isReceive = [weakSelf.messageModel.receiveMoney floatValue] > 0.009;
    
    switch (weakSelf.messageModel.statusType) {
            
        case RPRedpacketStatusTypeCanGrab:
        case RPRedpacketStatusTypeGrabFinish: {
            // 判断自己是否抢过
            if (weakSelf.messageModel.isSender){
                
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
                
            }else if (isReceive){
                
                [weakSelf showRedPacketDetailViewController:weakSelf.messageModel];
                
            }else{
                
                [weakSelf setingPacketViewWith:weakSelf.messageModel
                                 boxStatusType:RedpacketBoxStatusTypeMember
                              closeButtonBlock:^(RPRedpacketPreView *packetView){
                                  
                    [weakSelf removeRedPacketView];
                                  
                } submitButtonBlock:^(RedpacketBoxStatusType boxStatusType, RPRedpacketPreView *packetView) {
                    
                    if ([weakSelf.messageModel.receiver.userID isEqualToString:[RPRedpacketAliauth redpacketCurrentUser].userID]) {
                        
                        [weakSelf.delegate sendGrabRedpacketRequest:weakSelf.messageModel];
                        
                    }
                    
                }];
                
            }
            
        }
            break;
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
