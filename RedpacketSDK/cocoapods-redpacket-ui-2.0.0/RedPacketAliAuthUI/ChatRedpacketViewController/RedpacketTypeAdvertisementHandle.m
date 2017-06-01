//
//  RedpacketTypeAdvertisementHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeAdvertisementHandle.h"
#import "RPRedpacketModel.h"
#import "RPRedpacketManager.h"


@implementation RedpacketTypeAdvertisementHandle

- (void)getRedpacketDetail {
    [super getRedpacketDetail];
    [self showRedPacketDetailViewController:self.messageModel];
    [RPRedpacketAnalysiser redpacketAdverOpenEventWithRedpacketID:self.messageModel.redpacketID];
}

@end
