//
//  RPSendAmountPacketViewController.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/10/24.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPSendAmountPacketViewController.h"
#import "RPSendAmountRedpacketPreView.h"
#import "RPLayout.h"
#import "RPRedpacketSendControl.h"
#import "RPRedpacketBridge.h"
#import "RPRedpacketSetting.h"


@interface RPSendAmountPacketViewController ()

@property (nonatomic,strong)RPRedpacketSendControl * payControl;

@end

@implementation RPSendAmountPacketViewController

- (void)dealloc
{
    [RPRedpacketSendControl releaseSendControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [RedpacketColorStore flashColorWithRed:0 green:0 blue:0 alpha:0.8];
    RPSendAmountRedpacketPreView * preView = (RPSendAmountRedpacketPreView *)[RPRedpacketPreView preViewWithBoxStatusType:RedpacketBoxStatusTypeSendAmount];
    preView.receiver = self.conversationInfo;
    [self.view addSubview:preView];
    
    [preView rpm_makeConstraints:^(RPConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.sizeOffset(CGSizeMake(RP_SCREENWIDTH - 56, (RP_SCREENWIDTH - 56) * 418.0 / 320.0));
    }];
    
    rpWeakSelf;
    preView.convertActionBlock = ^(void) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(convertRedpacketViewcontrollerFromViewController:)] && weakSelf.parentViewController) {
            [weakSelf.delegate convertRedpacketViewcontrollerFromViewController:weakSelf.parentViewController];
        }
        
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
        
    };
    
    [preView setCloseButtonBlock:^(RPRedpacketPreView * packetView) {
        
        [RPRedpacketSendControl releaseSendControl];
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
        
    }];
    
    [preView setSubmitButtonBlock:^(RedpacketBoxStatusType boxStatusType, RPRedpacketPreView * packetView) {
        
        RPRedpacketSendControl *control = [RPRedpacketSendControl currentControl];
        control.hostViewController = weakSelf.hostViewController;
        
        [control payMoney:packetView.messageModel.money withMessageModel:packetView.messageModel inController:self andSuccessBlock:^(id object) {
           
            RPRedpacketModel *redpacketModel = (RPRedpacketModel *)object;
            
            if (weakSelf.sendRedPacketBlock) {
                weakSelf.sendRedPacketBlock(redpacketModel);
                [weakSelf.view removeFromSuperview];
                [weakSelf removeFromParentViewController];
            }
            
        }];
        
    }];
    
    RPRedpacketModel *model = preView.messageModel;
    preView.messageModel = model;
    [self.view rp_popupSubView:preView
                    atPosition:PopAnchorCenterX | PopAnchorCenterY];
    
}

- (void)configViewStyle
{
    
}

@end
