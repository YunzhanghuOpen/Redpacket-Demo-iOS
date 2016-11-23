//
//  RedpacketSingleViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketSingleViewController.h"
#import "RedpacketConfig.h"
#import "RedpacketMessageModel.h"
#import "RedpacketUser.h"


@interface RedpacketSingleViewController ()

@property (nonatomic, strong) IBOutlet UIButton *redpacketButton;
@property (nonatomic, strong) IBOutlet UIButton *randRedpacketButton;
@property (nonatomic, strong) IBOutlet UIButton *transferButton;

@end


@implementation RedpacketSingleViewController


- (IBAction)redpacketButtonClick:(id)sender
{
    [[RedpacketConfig sharedConfig] presentRedpacketSendViewController];
}

- (IBAction)randRedpacketButtonClick:(id)sender
{
    [[RedpacketConfig sharedConfig] presentRandRedpacketSendViewController];
}

- (IBAction)transferButtonClick:(id)sender
{
    UserInfo *transferToUser = [RedpacketUser currentUser].talkingUserInfo;
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = transferToUser.userId;
    userInfo.userNickname = transferToUser.userNickName;
    userInfo.userAvatar = transferToUser.userAvatar;
    
    [[RedpacketConfig sharedConfig] presentTransferViewController:userInfo];
}




@end
