//
//  RedpacketViewControl.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketViewControl.h"
#import "UIView+YZHPrompting.h"
#import "RedPacketDetailViewController.h"
#import "YZTransparent.h"
#import "RPSendRedPacketViewController.h"
#import "RPRedpackeNavgationController.h"
#import "RPSendAmountPacketViewController.h"
#import "RedpacketTypeBaseHandle.h"
#import "RPSoundPlayer.h"
#import "RPRedpacketBridge.h"
#import "UIViewController+RP_Private.h"
#import "UIAlertView+YZHAlert.h"
#import "RPReceiptsInAlipayViewController.h"
#import "RPAliPayEmpower.h"
#import "RPRedpacketErrorCode.h"
#import "RPRedpacketManager.h"
#import "RPRedpacketModel.h"
#import "RPUserInfo.h"

#define __NoneCurrtViewController__         @"请设置FromViewController参数"
#define __NoneDelegateOfMembersRedpacket__  @"定向红包没有设置Delegate,设置位于RedpacketViewControl中的Delegate"
#define __NoneConversationInfo__            @"请设置当前聊天对象ReveciverInfo"
#define __NoneRedpacketSendBlock__          @"请设置发红包成功后的回调SendBlock"
#define __NoneRedpacketGrabBlock__          @"请设置发红包成功后的回调GrabBlock"
#define __AnValiableTransferFunction__      @"此版本不支持转账功能"


@interface RedpacketViewControl ()<RedpacketHandleDelegate,RPSendAmountPacketViewControllerDelegate>

@property (nonatomic,   copy) RedpacketGrabBlock redpacketGrabBlock;
@property (nonatomic,   copy) RedpacketSendBlock redpacketSendBlock;
@property (nonatomic, strong) RedpacketTypeBaseHandle *redpacketHandle;
@property (nonatomic,   weak) UIViewController * fromViewController;
@property (nonatomic, strong) RPUserInfo *converstationInfo;
@property (nonatomic,   copy) RedpacketAdvertisementActionBlock advertisementAction;

@end


@implementation RedpacketViewControl

- (void)dealloc {
    
    RPDebug(@"~~dealloc:%@", NSStringFromClass([self class]));
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        //  注册收红包的声音
        [RPSoundPlayer regisitSoundId];
        
    }
    
    return self;
}

+ (void)redpacketTouchedWithMessageModel:(RPRedpacketModel *)model
                      fromViewController:(UIViewController *)fromViewController
                      redpacketGrabBlock:(RedpacketGrabBlock)grabTouch
                     advertisementAction:(RedpacketAdvertisementActionBlock)advertisementAction{

    NSAssert(fromViewController, __NoneCurrtViewController__);
    
        RedpacketViewControl * control = fromViewController.rp_control;
    
        if (!fromViewController.rp_control) {
            
            control = [RedpacketViewControl new];
            fromViewController.rp_control = control;
            
        }
    
        control.fromViewController = fromViewController;
        control.redpacketGrabBlock = grabTouch;
        control.advertisementAction = advertisementAction;
            
        __weak typeof(control) weakControl = control;
            
        [fromViewController.view rp_showHudWaitingView:YZHPromptTypeWating];
    
        // 获取红包详情
        [RedpacketTypeBaseHandle handleWithMessageModel:model
                                                success:^(RedpacketTypeBaseHandle *handle) {
            
            [fromViewController.view rp_removeHudInManaual];
            weakControl.redpacketHandle = handle;
            weakControl.redpacketHandle.fromViewController = fromViewController;
            weakControl.redpacketHandle.delegate = weakControl;
            [weakControl.redpacketHandle getRedpacketDetail];
            
        } failure:^(NSString *errorMsg, NSInteger errorCode) {
            
            [fromViewController.view rp_removeHudInManaual];
            
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:errorMsg
                                       delegate:nil
                              cancelButtonTitle:@"我知道了"
                              otherButtonTitles:nil] show];
            
        }];
}

//  拆红包
- (void)sendGrabRedpacketRequest:(RPRedpacketModel *)messageModel {
    
    rpWeakSelf;
    
    [weakSelf.fromViewController.view rp_showHudWaitingView:YZHPromptTypeWating];
    
    [RPRedpacketReceiver grabRedpacket:messageModel
                          andGrabBlock:^(NSError *error, RPRedpacketModel *model) {
        
        if (error) {
            
            if (error.code != RedpacketUnAliAuthed) {
                
                [weakSelf.redpacketHandle removeRedPacketView];
                
            }else {
                
                [weakSelf.redpacketHandle removeRedPacketView:NO];
                [weakSelf.fromViewController.view rp_removeHudInManaual];
                
                [RPAliPayEmpower aliEmpowerSuccess:^{
                    
                    [weakSelf.fromViewController.view rp_removeHudInManaual];
                    
                } failure:^(NSString *errorString) {
                    
                    [weakSelf.fromViewController.view rp_showHudErrorView:errorString];
                    
                }];
                
                return ;
            }
            
            [weakSelf.fromViewController.view rp_removeHudInManaual];
            
            if (error.code == NSIntegerMax) {
                
                [weakSelf.fromViewController.view rp_showHudErrorView:error.localizedDescription];
                
            } else {
                
                if (error.code == RedpacketCompleted) {
                    
                    // 需要将数字改成type类型
                    // 出现拆红包界面 但是拆开的时候没有了，则为这个code
                    
                    RedpacketBoxStatusType boxStatusType = -1;
                    
                    if (messageModel.redpacketType == RPRedpacketTypeGroupAvg ||
                        messageModel.redpacketType == RPRedpacketTypeSystem) {
                        
                        boxStatusType = RedpacketBoxStatusTypeAvgRobbing;
                        
                    }else if (messageModel.redpacketType == RPRedpacketTypeGroupRand){
                        
                        boxStatusType = RedpacketBoxStatusTypeRandRobbing;
                    }
                    
                    [weakSelf.redpacketHandle setingPacketViewWith:messageModel
                                                     boxStatusType:boxStatusType
                                                  closeButtonBlock:^(RPRedpacketPreView *packetView) {
                                                      
                                                      [weakSelf.redpacketHandle removeRedPacketView];
                                                      
                    } submitButtonBlock:^(RedpacketBoxStatusType boxStatusType, RPRedpacketPreView *packetView) {
                        
                        if (packetView.boxStatusType == RedpacketBoxStatusTypeRandRobbing) {
                            
                            [weakSelf.redpacketHandle showRedPacketDetailViewController:weakSelf.redpacketHandle.messageModel];
                            
                        } else {
                            
                            [weakSelf.redpacketHandle getRedpacketDetail];
                            
                        }
                        
                    }];
                    
                }else if (error.code == RedpacketGetReceivedBefore){
                    
                    // 需要将数字改成type类型
                    [weakSelf.redpacketHandle showRedPacketDetailViewController:messageModel];
                    
                }else{
                    
                    [weakSelf.fromViewController.view rp_showHudErrorView:error.localizedDescription];
                    
                }
            }
            
        } else {
            
            [weakSelf.fromViewController.view rp_removeHudInManaual];
            
            // mark？？ 这个和下边的重复？？
            [weakSelf.redpacketHandle showRedPacketDetailViewController:model];
            
            // 拼手气红包需要拆分显示
            switch (messageModel.redpacketType) {
                    
                case RPRedpacketTypeGroupRand:
                case RPRedpacketTypeGoupMember:
                    
                    [weakSelf.redpacketHandle getRedpacketDetail];
                    break;
                    
                case RPRedpacketTypeAmount:
                    
                    [weakSelf.redpacketHandle getRedpacketDetail];
                    break;
                    
                default:
                    break;
                    
            }
            
            if (messageModel.redpacketType != RPRedpacketTypeAmount) {
                
                [weakSelf.redpacketHandle removeRedPacketView];
                
            }
            
            if (weakSelf.redpacketGrabBlock) {
                
                //播放声音
                [RPSoundPlayer playRedpacketOpenSound];
                weakSelf.redpacketGrabBlock(model);
                
            }
        }
  
    }];
}

//  广告红包点击相关链接时的回调
- (void)advertisementRedPacketAction:(RPAdvertInfo *)advertInfo {
    
    if (self.advertisementAction) {
        
        self.advertisementAction(advertInfo);
        
    }
    
}

#pragma mark 发红包
+ (void)presentRedpacketViewController:(RPRedpacketControllerType)redpacketType
                       fromeController:(UIViewController *)fromeController
                      groupMemberCount:(NSInteger)count
                 withRedpacketReceiver:(RPUserInfo *)receiver
                       andSuccessBlock:(RedpacketSendBlock)sendBlock
         withFetchGroupMemberListBlock:(RedpacketMemberListBlock)memberBlock {
    
    NSAssert(fromeController, __NoneCurrtViewController__);
    NSAssert(receiver, __NoneConversationInfo__);
    NSAssert(sendBlock, __NoneRedpacketSendBlock__);
    
    RedpacketViewControl * control = [RedpacketViewControl new];
    fromeController.rp_control = control;
    
    control.converstationInfo = receiver;
    control.fromViewController = fromeController;
    control.redpacketSendBlock = sendBlock;
    
    if (redpacketType == RPRedpacketControllerTypeRand) {
        
        //  小额随机红包
        RPSendAmountPacketViewController * redpacketController = [RPSendAmountPacketViewController new];
        redpacketController.delegate = control;
        redpacketController.conversationInfo = receiver;
        redpacketController.sendRedPacketBlock = sendBlock;
        redpacketController.hostViewController = fromeController;
        [fromeController addChildViewController:redpacketController];
        redpacketController.view.frame = CGRectMake(0, 0, CGRectGetWidth(fromeController.view.frame), CGRectGetHeight(fromeController.view.frame));
        [fromeController.view addSubview:redpacketController.view];
        
    }else {
        
        //  普通红包
        RPSendRedPacketViewControllerType controllerType;
        switch (redpacketType) {
                
            case RPRedpacketControllerTypeGroup:
                controllerType = memberBlock ? RPSendRedPacketViewControllerMember : RPSendRedPacketViewControllerGroup;
                break;
                
            default:
                controllerType = RPSendRedPacketViewControllerSingle;
                break;
                
        }
        
        RPSendRedPacketViewController * redpacketController = [[RPSendRedPacketViewController alloc] initWithControllerType:controllerType];
        redpacketController.conversationInfo = receiver;
        redpacketController.sendRedPacketBlock = sendBlock;
        redpacketController.hostController = fromeController;
        redpacketController.fetchBlock = memberBlock;
        [redpacketController setMemberCount:count];
        RPRedpackeNavgationController *navigationController = [[RPRedpackeNavgationController alloc] initWithRootViewController:redpacketController];
        [fromeController presentViewController:navigationController animated:YES completion:nil];
    
    }

}

//  小额随机红包切换到点对点红包
- (void)convertRedpacketViewcontrollerFromViewController:(UIViewController *)fromController {
    
    [self.class presentRedpacketViewController:RPRedpacketControllerTypeSingle
                               fromeController:fromController
                              groupMemberCount:0
                         withRedpacketReceiver:self.converstationInfo
                               andSuccessBlock:self.redpacketSendBlock
                 withFetchGroupMemberListBlock:nil];
    
}

#pragma mark -

//  红包收发记录页面
+ (void)presentChangePocketViewControllerFromeController:(UIViewController *)viewController
{
    UIViewController *controller = [[RPReceiptsInAlipayViewController alloc] initWithStyle:UITableViewStyleGrouped];
    RPRedpackeNavgationController *navigation = [[RPRedpackeNavgationController alloc] initWithRootViewController:controller];
    
    [viewController presentViewController:navigation
                                 animated:YES
                               completion:nil];
    
}

@end

