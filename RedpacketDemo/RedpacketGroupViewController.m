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
#import "RedpacketDefines.h"

@interface RedpacketGroupViewController ()

@property (weak, nonatomic) IBOutlet UIButton *redpacket;
@property (weak, nonatomic) IBOutlet UIButton *member;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImageView;

@end

@implementation RedpacketGroupViewController

- (IBAction)groupRedpacketButtonClicked
{
    [self presentRedpacketViewController:RPRedpacketControllerTypeGroup
                isSupportMemberRedpacket:NO];
}

- (IBAction)memberRedpacketButtonClicked
{
    [self presentRedpacketViewController:RPRedpacketControllerTypeGroup
                isSupportMemberRedpacket:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.redpacket setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
    [self.member setTitleColor:rpHexColor(0xd24f44) forState:UIControlStateNormal];
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
}

@end
