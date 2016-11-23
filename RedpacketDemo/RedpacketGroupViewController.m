//
//  RedpacketGroupViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/19.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketGroupViewController.h"
#import "RedpacketConfig.h"
#import "RedpacketUser.h"
#import "RedpacketMessageModel.h"


@implementation RedpacketGroupViewController

- (IBAction)groupRedpacketButtonClicked
{
    RedpacketUser *userInfo = [RedpacketUser currentUser];
    [[RedpacketConfig sharedConfig] presentGroupRedpacketSendViewControllerWithMemeberCount:userInfo.users.count];
}

- (IBAction)memberRedpacketButtonClicked
{
    RedpacketUser *userInfo = [RedpacketUser currentUser];
    [[RedpacketConfig sharedConfig] presentMemberGroupRedpacketViewControllerWithMemberCount:userInfo.users.count];
}

@end
