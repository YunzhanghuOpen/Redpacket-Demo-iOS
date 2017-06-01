//
//  RPSendAmountPacketViewController.h
//  RedpacketLib
//
//  Created by 都基鹏 on 16/10/24.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPBaseViewController.h"
#import "RPRedpacketModel.h"

@protocol RPSendAmountPacketViewControllerDelegate <NSObject>

- (void)convertRedpacketViewcontrollerFromViewController:(UIViewController *)fromController;

@end

@interface RPSendAmountPacketViewController : RPBaseViewController

/**
 *  会话信息，可能是个人也可能是群组
 */
@property (nonatomic,weak)  RPUserInfo *conversationInfo;
@property (nonatomic, weak) UIViewController *hostViewController;
/**
 *  发送红包回调
 */
@property (nonatomic,copy)  void(^sendRedPacketBlock)(RPRedpacketModel *model);

@property (nonatomic,weak)  id<RPSendAmountPacketViewControllerDelegate> delegate;

@property (nonatomic,strong) RPRedpacketModel *redpacketModel;

@end
