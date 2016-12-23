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

