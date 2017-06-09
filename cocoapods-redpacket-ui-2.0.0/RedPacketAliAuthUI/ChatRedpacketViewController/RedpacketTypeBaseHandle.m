//
//  RedpacketTypeBaseHandle.m
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketTypeBaseHandle.h"
#import "RedpacketTypeSingleHandle.h"
#import "RedpacketTypeMemberHandle.h"
#import "RedpacketTypeRandHandle.h"
#import "RedpacketTypeAvgHandle.h"
#import "RedpacketTypeRandpiHandle.h"
#import "RedpacketTypeAdvertisementHandle.h"
#import "YZTransparent.h"
#import "UIView+YZHAnimation.h"
#import "RedpacketTypeAmountHandle.h"
#import "RedPacketDetailViewController.h"
#import "RPRedpackeNavgationController.h"
#import "RPAdvertisementDetailViewContrroller.h"
#import "RPRedpacketManager.h"

#define RedpacketPreViewTag 70001


@interface RedpacketTypeBaseHandle()

@property (nonatomic, weak) RedPacketDetailViewController *packetDetailViewController;

@end


@implementation RedpacketTypeBaseHandle

+ (void)handleWithMessageModel:(RPRedpacketModel *)model
                       success:(void (^)(RedpacketTypeBaseHandle *))successblock
                       failure:(void (^)(NSString *, NSInteger))failureBlock {
    //查询红包详情及状态
    [RPRedpacketReceiver fetchRedpacketStatus:model andFetchBlock:^(NSError *error, RPRedpacketModel *model) {
        if (error) {
            failureBlock(error.localizedDescription,error.code);
        } else {
            RedpacketTypeBaseHandle *handle = [[self class] handleWithmessageModel:model];
            successblock(handle);
        }
    }];
}


+ (instancetype)handleWithmessageModel:(RPRedpacketModel *)messageModel{
    RedpacketTypeBaseHandle * handle;
    switch (messageModel.redpacketType) {
        case RPRedpacketTypeSingle: {
            handle = [RedpacketTypeSingleHandle new];
            break;
        }
        case RPRedpacketTypeGroupRand:{
            handle = [RedpacketTypeRandHandle new];
            break;
        }
        case RPRedpacketTypeGroupAvg:{
            handle = [RedpacketTypeAvgHandle new];
            break;
        }
        case RPRedpacketTypeSystem: {
            handle = [RedpacketTypeRandpiHandle new];
            break;
        }
        case RPRedpacketTypeGoupMember: {
            handle = [RedpacketTypeMemberHandle new];
            break;
        }
        case RPRedpacketTypeAdvertisement: {
            handle = [RedpacketTypeAdvertisementHandle new];
            break;
        }
        case RPRedpacketTypeAmount:{
            handle = [RedpacketTypeAmountHandle new];
            break;
        }
        default:
            NSParameterAssert(messageModel.redpacketType);
            break;
    }
    handle.messageModel = messageModel;
    return handle;
}

- (void)getRedpacketDetail {
    //  检查有没有实现代理
    if (![self.delegate conformsToProtocol:@protocol(RedpacketHandleDelegate)]) {
       @throw [NSException exceptionWithName:@"RedpacketTypeBaseHandle" reason:@"RedpacketHandleDelegate" userInfo:nil];
    }
}

- (void)showRedPacketDetailViewController:(RPRedpacketModel *)messageModel {
    switch (messageModel.redpacketType) {
        case RPRedpacketTypeSingle:
        case RPRedpacketTypeGroupRand:
        case RPRedpacketTypeGroupAvg:
        case RPRedpacketTypeSystem:
        case RPRedpacketTypeGoupMember: {
            if (!_packetDetailViewController) {
                RedPacketDetailViewController *controller = [[RedPacketDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
                _packetDetailViewController = controller;
                RPRedpackeNavgationController *navigation = [[RPRedpackeNavgationController alloc] initWithRootViewController:controller];
                [self.fromViewController presentViewController:navigation animated:YES completion:nil];
            }
            _packetDetailViewController.messageModel = messageModel;
            break;
        }
        case RPRedpacketTypeAdvertisement: {
            RPAdvertisementDetailViewContrroller *controller = [[RPAdvertisementDetailViewContrroller alloc] init];
            rpWeakSelf;
            controller.advertisementDetailAction = ^(RPAdvertInfo *adverInfo) {
                if ([weakSelf.delegate respondsToSelector:@selector(advertisementRedPacketAction:)]) {
                    [weakSelf.delegate advertisementRedPacketAction:adverInfo];
                }
            };
            controller.messageModel = messageModel;
            RPRedpackeNavgationController *navigation = [[RPRedpackeNavgationController alloc] initWithRootViewController:controller];
            [self.fromViewController presentViewController:navigation animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end


@implementation RedpacketTypeBaseHandle(infoView)

- (void)setingPacketViewWith:(RPRedpacketModel *)messageModel
               boxStatusType:(RedpacketBoxStatusType)BoxStatusType
            closeButtonBlock:(void (^)(RPRedpacketPreView * packetView))closeButtonBlock
           submitButtonBlock:(void(^)(RedpacketBoxStatusType boxStatusType,RPRedpacketPreView * packetView))submitButtonBlock {
    [self removeRedPacketView];
    RPRedpacketPreView *packetView = [[RPRedpacketPreView alloc] initWithRedpacketBoxStatusType:BoxStatusType];;
    __weak RedpacketTypeBaseHandle *weakSelf = self;
    [YZTransparent showInView:self.fromViewController.view touchBlock:^(YZTransparent *view) {
        [weakSelf removeRedPacketView:YES];
    }];
    
    packetView.messageModel = messageModel;
    packetView.boxStatusType = BoxStatusType;
    [packetView setCloseButtonBlock:closeButtonBlock];
    [packetView setSubmitButtonBlock:submitButtonBlock];
    [self popSubView:packetView];
}

- (void)removeRedPacketView {
    [self removeRedPacketView:YES];
}

- (void)removeRedPacketView:(BOOL)animated {
    UIView *redpacket = [self.fromViewController.view viewWithTag:RedpacketPreViewTag];
    [YZTransparent removeFromSuperView];
    if (redpacket) {
        if (animated) {
            __weak UIView *weakRedpacket = redpacket;
            [redpacket rp_shrinkDispaerWithCompletionBlock:^{
                [weakRedpacket removeFromSuperview];
            }];
        }else {
            [redpacket removeFromSuperview];
        }
    }
}

- (void)popSubView:(UIView *)view {
    view.frame = CGRectMake(28, 100, [UIScreen mainScreen].bounds.size.width - 56, ([UIScreen mainScreen].bounds.size.width - 56)*418.0/320.0);
    view.center = CGPointMake(CGRectGetWidth(self.fromViewController.view.frame) / 2, CGRectGetHeight(self.fromViewController.view.frame) / 2);
    view.tag = RedpacketPreViewTag;
    [self.fromViewController.view rp_popupSubView:view
                                       atPosition:PopAnchorCenterX | PopAnchorCenterY];
}

@end
