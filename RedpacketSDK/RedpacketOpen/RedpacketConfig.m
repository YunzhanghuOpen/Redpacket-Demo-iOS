//
//  RedpacketConfig1.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/10/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketConfig.h"
#import "YZHRedpacketBridge.h"
#import "YZHRedpacketBridgeProtocol.h"
#import <AFNetworking.h>
#import "RedpacketLib.h"
#import "RedpacketMessageCell.h"
#import "RedpacketTakenMessageTipCell.h"
#import "RedpacketUser.h"
#import "WXApi.h"

static NSString *requestUrl1 = @"https://rpv2.yunzhanghu.com/api/sign?duid=";

#define WechatPayAppID      @"wx634a5f53be1b66bd"

@implementation NSDictionary (ValueForKey)

- (NSString *)stringValueForKey:(NSString *)key;
{
    id value = [self valueForKey:key];
    
    return [NSString stringWithFormat:@"%@", value];
}

@end

@interface RedpacketConfig () <YZHRedpacketBridgeDelegate, YZHRedpacketBridgeDataSource>

@property (nonatomic, strong)   RedpacketViewControl *viewControl;

@property (nonatomic, copy) RedpacketSendPacketBlock sendBlock;
@property (nonatomic, copy) RedpacketGrabPacketBlock grabBlock;


@end


@implementation RedpacketConfig

+ (RedpacketConfig *)sharedConfig
{
    static RedpacketConfig *__redpacketConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __redpacketConfig = [RedpacketConfig new];
    });
    
    return __redpacketConfig;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        [WXApi registerApp:WechatPayAppID withDescription:@"RedpacketSDK-iOS"];
        
        [YZHRedpacketBridge sharedBridge].delegate = self;
        [YZHRedpacketBridge sharedBridge].dataSource = self;
        [YZHRedpacketBridge sharedBridge].isDebug = YES;
        
        _viewControl = [RedpacketViewControl new];
        
        __weak RedpacketConfig *weakSelf = self;
        [_viewControl setRedpacketGrabBlock:^(RedpacketMessageModel *messageModel) {
            
            if (weakSelf.grabBlock) {
                weakSelf.grabBlock(messageModel.redpacketMessageModelToDic);
            }
            
        } andRedpacketBlock:^(RedpacketMessageModel *model) {
            
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(model.redpacketMessageModelToDic);
            }
            
        }];   
    }
    
    return self;
}

- (RedpacketUserInfo *)redpacketUserInfo
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = [RedpacketUser currentUser].userInfo.userId;
    userInfo.userNickname = [RedpacketUser currentUser].userInfo.userNickName;
    userInfo.userAvatar = [RedpacketUser currentUser].userInfo.userAvatar;
    
    return userInfo;
}

- (void)configViewControlWithCurrentController:(UIViewController *)controller
                           viewControlDeleagte:(id <RedpacketViewControlDelegate>)delegate
                           currentConversation:(RedpacketUserInfo *)info
                            redpacketSendBlock:(RedpacketSendPacketBlock)sendBlock
                         andRedpacketGrabBlock:(RedpacketGrabPacketBlock)grabBlock;
{
    _viewControl.conversationController = controller;
    _viewControl.delegate = delegate;
    _viewControl.converstationInfo = info;
    
    self.sendBlock = sendBlock;
    self.grabBlock = grabBlock;
}

/** 签名接口调用， 签名接口写法见官网文档 */
- (void)fetchUserSignWithUserID:(FetchRegisitParamBlock)fetchBlock
{
    NSString *userId = [self redpacketUserInfo].userId;
    if (userId) {
            
            // 获取应用自己的签名字段。实际应用中需要开发者自行提供相应在的签名计算服务
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl1, userId];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [[[AFHTTPRequestOperationManager manager] HTTPRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  
                                                                                  NSLog(@"ResponseSuccess");
                                                                                  [self configWithSignDict:responseObject andBlock:fetchBlock];
                                                                                  
                                                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  
                                                                                  NSLog(@"request redpacket sign failed:%@", error);
                                                                                  fetchBlock(nil);
                                                                                  
                                                                              }] start];
        }
}

- (void)configWithSignDict:(NSDictionary *)dict andBlock:(FetchRegisitParamBlock)fetchBlock
{
    NSString *partner = [dict stringValueForKey:@"partner"];
    NSString *appUserId = [dict stringValueForKey:@"user_id"];
    NSString *timeStamp = [dict stringValueForKey:@"timestamp"];
    NSString *sign = [dict stringValueForKey:@"sign"];
    
    RedpacketRegisitModel *model = [RedpacketRegisitModel signModelWithAppUserId:appUserId
                                                                      signString:sign
                                                                         partner:partner
                                                                    andTimeStamp:timeStamp];
    NSLog(@"ReturnModel");
    fetchBlock(model);
}

#pragma mark Redpacket
/** 红包SDK回调此函数进行注册 */
- (void)redpacketFetchRegisitParam:(FetchRegisitParamBlock)fetchBlock withError:(NSError *)error
{
    NSLog(@"RequestToken");
    [self fetchUserSignWithUserID:fetchBlock];
}

@end


@implementation RedpacketConfig (RedpacketControllers)

- (void)presentRedpacketSendViewController
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerSingle memberCount:0];
}

- (void)presentRandRedpacketSendViewController
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerRand memberCount:0];
}

- (void)presentTransferViewController:(RedpacketUserInfo *)userInfo
{
    [_viewControl presentTransferViewControllerWithReceiver:userInfo];
}

- (void)presentTransferDetailViewController:(RedpacketMessageModel *)model
{
    [_viewControl presentTransferDetailViewController:model];
}

/** RPSendRedPacketViewControllerGroup 为普通群红包，RPSendRedPacketViewControllerMember 为包含定向功能的群红包 */
- (void)presentGroupRedpacketSendViewControllerWithMemeberCount:(NSInteger)count
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerGroup memberCount:count];
}

- (void)presentMemberGroupRedpacketViewControllerWithMemberCount:(NSInteger)count
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerMember memberCount:count];
}

- (void)presentChangeViewControllerInController:(UIViewController *)viewController
{
    UIViewController *controller = [RedpacketViewControl changeMoneyController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [viewController presentViewController:nav animated:YES completion:nil];
}

- (void)grabRedpacket:(NSDictionary *)redpacketDic
{
    RedpacketMessageModel *messageModel = [RedpacketMessageModel redpacketMessageModelWithDic:redpacketDic];
 
    if (messageModel.messageType == RedpacketMessageTypeTransfer) {
        [self presentTransferDetailViewController:messageModel];
        
    }else {
        [_viewControl redpacketCellTouchedWithMessageModel:messageModel];
    }
    
}

- (UITableViewCell *)cellForRedpacketMessageDict:(NSDictionary *)dict
{
    NSDictionary *redpacketMessageDict = [dict valueForKey:@"1"];
    
    if (redpacketMessageDict) {
        
        RedpacketMessageModel *redpacketMessageModel = [RedpacketMessageModel redpacketMessageModelWithDic:redpacketMessageDict];
        RedpacketMessageCell *cell = [[RedpacketMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithRedpacketMessageModel:redpacketMessageModel andRedpacketDic:redpacketMessageDict];
        
        return cell;
        
    }else {
        
        redpacketMessageDict = [dict valueForKey:@"2"];
        RedpacketMessageModel *redpacketMessageModel = [RedpacketMessageModel redpacketMessageModelWithDic:redpacketMessageDict];
        RedpacketTakenMessageTipCell *tipCell = [[RedpacketTakenMessageTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [tipCell configWithRedpacketMessageModel:redpacketMessageModel];
        tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return tipCell;

    }
}

- (CGFloat)heightForRedpacketMessageDict:(NSDictionary *)dict
{
    NSDictionary *redpacketMessageDict = [dict valueForKey:@"1"];
    
    RedpacketMessageModel *redpacketMessageModel = [RedpacketMessageModel redpacketMessageModelWithDic:redpacketMessageDict];
    if (redpacketMessageDict) {
        return [RedpacketMessageCell heightForRedpacketMessageCell:redpacketMessageModel];
        
    }else {
        return [RedpacketTakenMessageTipCell heightForRedpacketMessageTipCell];
        
    }
    
}

@end

