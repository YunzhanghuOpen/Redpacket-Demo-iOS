//
//  RedpacketConfig1.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/10/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketConfig.h"
#import <AFNetworking.h>
#import "RedpacketMessageCell.h"
#import "RedpacketTakenMessageTipCell.h"
#import "RedpacketUser.h"
#import "RPRedpacketUnionHandle.h"
#import "RPRedpacketBridge.h"

static NSString *baseRequestURL = @"https://rpv2.yunzhanghu.com";
static NSString *tokenRequestURL = @"/api/demo-sign?token=1&uid=";


@implementation NSDictionary (ValueForKey)

- (NSString *)stringValueForKey:(NSString *)key;
{
    id value = [self valueForKey:key];
    
    return [NSString stringWithFormat:@"%@", value];
}

@end

@interface RedpacketConfig () <RPRedpacketBridgeDelegate>

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
        
        [RPRedpacketBridge sharedBridge].delegate = self;
        [RPRedpacketBridge sharedBridge].isDebug = YES;
        
    }
    
    return self;
}

- (RPUserInfo *)redpacketUserInfo
{
    RPUserInfo *userInfo = [RPUserInfo new];
    userInfo.userID = [RedpacketUser currentUser].userInfo.userId;
    userInfo.userName = [RedpacketUser currentUser].userInfo.userNickName;
    userInfo.avatar = [RedpacketUser currentUser].userInfo.userAvatarURL;
    
    return userInfo;
}

/** 签名接口调用， 签名接口写法见官网文档 */
- (void)fetchUserSignWithUserID:(RPFetchRegisitParamBlock)fetchBlock
{
    NSString *userId = [self redpacketUserInfo].userID;
    if (userId) {
        
        NSString *requestUser = [tokenRequestURL stringByAppendingString:userId];
        // 获取应用自己的签名字段。实际应用中需要开发者自行提供相应在的签名计算服务
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:baseRequestURL]];
        
        [manager GET:requestUser
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSLog(@"ResponseSuccess");
                 [self configWithSignDict:responseObject andBlock:fetchBlock];
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"request redpacket sign failed:%@", error);
                 fetchBlock(nil);
                 
             }];
        }
}

- (void)configWithSignDict:(NSDictionary *)dict andBlock:(RPFetchRegisitParamBlock)fetchBlock
{
    NSString *partner = [dict stringValueForKey:@"partner"];
    NSString *appUserId = [dict stringValueForKey:@"user_id"];
    NSString *timeStamp = [dict stringValueForKey:@"timestamp"];
    NSString *sign = [dict stringValueForKey:@"sign"];
    
    RPRedpacketRegisitModel *model = [RPRedpacketRegisitModel signModelWithAppUserId:appUserId
                                                                      signString:sign
                                                                         partner:partner
                                                                    andTimeStamp:timeStamp];
    NSLog(@"ReturnModel");
    fetchBlock(model);
}

#pragma mark Redpacket
/** 红包SDK回调此函数进行注册 */
- (void)redpacketFetchRegisitParam:(RPFetchRegisitParamBlock)fetchBlock withError:(NSError *)error
{
    NSLog(@"RequestToken");
    [self fetchUserSignWithUserID:fetchBlock];
}

@end


@implementation RedpacketConfig (RedpacketControllers)

- (UITableViewCell *)cellForRedpacketMessageDict:(NSDictionary *)dict
{
    NSDictionary *redpacketMessageDict = [dict valueForKey:@"1"];
    
    if (redpacketMessageDict) {
        
        AnalysisRedpacketModel *redpacketMessageModel = [AnalysisRedpacketModel analysisRedpacketWithDict:redpacketMessageDict andIsSender:nil];
        RedpacketMessageCell *cell = [[RedpacketMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithRedpacketMessageModel:redpacketMessageModel andRedpacketDic:redpacketMessageDict];
        
        return cell;
        
    }else {
        
        redpacketMessageDict = [dict valueForKey:@"2"];
        AnalysisRedpacketModel *redpacketMessageModel = [AnalysisRedpacketModel analysisRedpacketWithDict:redpacketMessageDict andIsSender:nil];
        RedpacketTakenMessageTipCell *tipCell = [[RedpacketTakenMessageTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [tipCell configWithRedpacketMessageModel:redpacketMessageModel];
        tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return tipCell;
        
    }
}

- (CGFloat)heightForRedpacketMessageDict:(NSDictionary *)dict
{
    NSDictionary *redpacketMessageDict = [dict valueForKey:@"1"];
    
    AnalysisRedpacketModel *redpacketMessageModel = [AnalysisRedpacketModel analysisRedpacketWithDict:redpacketMessageDict andIsSender:nil];
    if (redpacketMessageDict) {
        return [RedpacketMessageCell heightForRedpacketMessageCell:redpacketMessageModel];
        
    }else {
        return [RedpacketTakenMessageTipCell heightForRedpacketMessageTipCell];
        
    }
    
}

@end

