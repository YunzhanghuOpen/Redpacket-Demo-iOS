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

static NSString *baseRequestURL = @"https://rpv2.yunzhanghu.com";
static NSString *tokenRequestURL = @"/api/demo-sign?token=1&uid=";


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
        
        [YZHRedpacketBridge sharedBridge].delegate = self;
        [YZHRedpacketBridge sharedBridge].dataSource = self;
        [YZHRedpacketBridge sharedBridge].isDebug = YES;
        
    }
    
    return self;
}

- (RedpacketUserInfo *)redpacketUserInfo
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = [RedpacketUser currentUser].userInfo.userId;
    userInfo.userNickname = [RedpacketUser currentUser].userInfo.userNickName;
    userInfo.userAvatar = [RedpacketUser currentUser].userInfo.userAvatarURL;
    
    return userInfo;
}

/** 签名接口调用， 签名接口写法见官网文档 */
- (void)fetchUserSignWithUserID:(FetchRegisitParamBlock)fetchBlock
{
    NSString *userId = [self redpacketUserInfo].userId;
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

