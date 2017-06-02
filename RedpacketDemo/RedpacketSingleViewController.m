//
//  RedpacketSingleViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketSingleViewController.h"
#import "RedpacketConfig.h"
#import "RPRedpacketModel.h"
#import "RedpacketUser.h"
#import "RedpacketDefines.h"
#import  "RedpacketViewControl.h"


@interface RedpacketSingleViewController ()

@property (nonatomic, strong) IBOutlet UIButton *redpacketButton;
@property (nonatomic, strong) IBOutlet UIButton *randRedpacketButton;
@property (nonatomic, strong) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UIButton *redpacket;
@property (weak, nonatomic) IBOutlet UIButton *redpacketRandom;
@property (weak, nonatomic) IBOutlet UIButton *transfer;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation RedpacketSingleViewController


- (IBAction)redpacketButtonClick:(id)sender
{
    [self presentRedpacketViewController:RPRedpacketControllerTypeSingle];
}

- (IBAction)randRedpacketButtonClick:(id)sender
{
    [self presentRedpacketViewController:RPRedpacketControllerTypeRand];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.redpacket setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
    [self.redpacketRandom setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
    [self.transfer setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
    self.headerBackImageView.backgroundColor = rpHexColor(0xd24f44);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = [NSString stringWithFormat:@"当前用户：%@",[RedpacketUser currentUser].userInfo.userNickName];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.navigationBar.tintColor = rpHexColor(0xd3d97a);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : rpHexColor(0xd3d97a)}];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)userChangeItemClick
{
    //  测试目的：切换只在User1和User2之间切换
    [[RedpacketUser currentUser] changeUserBetweenUser1AndUser2];
    
    self.nameLabel.text = [NSString stringWithFormat:@"当前用户：%@",[RedpacketUser currentUser].userInfo.userNickName];
    [self.talkTableView reloadData];
    RPUserInfo *userInfo = [RPUserInfo new];
    userInfo.userName = [RedpacketUser currentUser].talkingUserInfo.userNickName;
    userInfo.userID = [RedpacketUser currentUser].talkingUserInfo.userId;
    userInfo.avatar = [RedpacketUser currentUser].talkingUserInfo.userAvatarURL;
}


@end
