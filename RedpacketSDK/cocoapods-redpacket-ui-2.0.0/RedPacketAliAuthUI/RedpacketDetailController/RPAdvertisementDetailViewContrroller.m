//
//  RPDetailViewContrroller.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/7.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPAdvertisementDetailViewContrroller.h"
#import "RPRedpacketSetting.h"
#import "RPAdvertisementDetailView.h"
#import "RPSoundPlayer.h"
#import "RPRedpacketManager.h"
#import "RPAlipayAuth.h"
#import "RPReceiptsInAlipayViewController.h"
#import "RPAliPayEmpower.h"
#import "RPRedpacketErrorCode.h"

@interface RPAdvertisementDetailViewContrroller ()<RPAdvertisementDetailViewDelegate>

@property (nonatomic, weak) RPAdvertisementDetailView * detailView;

@end


@implementation RPAdvertisementDetailViewContrroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLable.text = @"红包";
    self.cuttingLineHidden = YES;
    [self configViewStyle];
    
    RPAdvertisementDetailView * advertisementDetailView = [[RPAdvertisementDetailView alloc] initWithFrame:self.view.frame];
    advertisementDetailView.rpDelegate = self;
    [self.view addSubview:advertisementDetailView];
    self.detailView = advertisementDetailView;
    
    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:advertisementDetailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem:advertisementDetailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:advertisementDetailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:advertisementDetailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraints:@[topConstraint,leftConstraint,rightConstraint,bottomConstraint]];
    [self.detailView setDetailModel:self.messageModel];
}

- (void)configViewStyle {
    [super configViewStyle];
    [self setNavgationBarBackgroundColor:[RedpacketColorStore rp_textColorRed]
                              titleColor:[RedpacketColorStore rp_textcolorYellow]
                         leftButtonTitle:@"关闭"
                        rightButtonTitle:nil];
    [self.navigationController.navigationBar insertSubview:[[UIImageView alloc]
                                             initWithImage:rp_imageWithColor([RedpacketColorStore rp_textColorRed])]
                                                   atIndex:0];
    self.subLable.text = [NSString stringWithFormat:@"%@红包服务", [RPRedpacketSetting shareInstance].redpacketOrgName];
}

- (void)getRedpacket {
    
    rpWeakSelf;
    [weakSelf.view rp_showHudWaitingView:YZHPromptTypeWating];
    [RPRedpacketReceiver grabRedpacket:self.messageModel
                          andGrabBlock:^(NSError *error, RPRedpacketModel *model) {
        [weakSelf.view rp_removeHudInManaual];
        NSInteger code = error.code;
        if (!error) {
            [RPSoundPlayer playRedpacketOpenSound];
            [weakSelf.detailView setDetailModel:self.messageModel];
        } else {
            if (code != 60201) {
                /*支付宝支付版本，支付宝未授权*/
                if (code == RedpacketCompleted) {
                    /*出现拆红包界面，拆而未抢到*/
                    [RPRedpacketReceiver fetchRedpacketDetail:self.messageModel
                                               userListLength:0 andFetchBlock:^(NSError *error, RPRedpacketModel *model) {
                                                   if (!error) {
                                                       [weakSelf.detailView setDetailModel:model];
                                                   } else {
                                                       [weakSelf.view rp_showHudErrorView:error.localizedDescription];
                                                   }
                                               }];
                }else {
                    [weakSelf.view rp_showHudErrorView:error.localizedDescription];
                }
            }else {
                [RPAliPayEmpower aliEmpowerSuccess:nil
                                           failure:^(NSString *errorString) {
                    [weakSelf.view rp_showHudErrorView:errorString];
                }];
            }
        }
    }];
}

- (void)clickButtonLeft {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)advertisementRedPacketAction:(RPAdvertInfo *)advertInfo {
    self.advertisementDetailAction(advertInfo);
}

@end

