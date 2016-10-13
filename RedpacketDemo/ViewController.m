//
//  ViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 16/9/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "RedpacketLib.h"
#import "YZHRedpacketBridge.h"
#import <AFHTTPRequestOperationManager.h>

static NSString *requestUrl = @"https://rpv2.yunzhanghu.com/api/sign?duid=";//@"http://10.3.158.63:443/api/sign?duid=";

@implementation NSDictionary (ValueForKey)

- (NSString *)stringValueForKey:(NSString *)key;
{
    id value = [self valueForKey:key];
    
    return [NSString stringWithFormat:@"%@", value];
}

@end

@interface ViewController () <YZHRedpacketBridgeDelegate, YZHRedpacketBridgeDataSource, RedpacketViewControlDelegate>
{
    BOOL _isTest1;
}

@property (nonatomic, strong) RedpacketViewControl *viewControl;

@property (nonatomic, strong) RedpacketMessageModel *redpacketModel;

@property (nonatomic, strong)   IBOutlet UITextField *userInfoField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isTest1 = YES;
    
    [self initRedpacketInfo];
    [self initRedpacketSend];
    
    [self loadUser];
}

- (IBAction)userTest1:(id)sender
{
    
    _isTest1 = YES;
    
    [self loadUser];
}

- (IBAction)userTest2:(id)sender
{
    NSLog(@"Hello");
    _isTest1 = NO;
    
    [self loadUser];
}


#pragma mark -
- (IBAction)changeViewController:(id)sender
{
    [_viewControl presentChangeMoneyViewController];
}

- (IBAction)grabRedpacket:(id)sender
{
    [_viewControl redpacketCellTouchedWithMessageModel:self.redpacketModel];
}

#pragma mark - RedpacketSend
- (IBAction)sendSingleRedpacket:(id)sender
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerSingle memberCount:0];
}

- (IBAction)sendGroupRedpacket:(id)sender
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerGroup memberCount:0];
}

- (IBAction)sendMemberRedpacket:(id)sender
{
    [_viewControl presentRedPacketViewControllerWithType:RPSendRedPacketViewControllerMember memberCount:3];
}

#pragma mark - Transfer

- (IBAction)transferViewControllerSender:(id)sender
{
    [_viewControl presentTransferViewControllerWithReceiver:self.userTest2Info];
}

- (IBAction)transerDetailSender:(id)sender
{
    [_viewControl presentTransferDetailViewController:self.redpacketModel];
}

#pragma mark -

- (RedpacketUserInfo *)userTest1Info
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = @"test";
    userInfo.userNickname = @"test";
    
    return userInfo;
}

- (RedpacketUserInfo *)userTest2Info
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = @"test2";
    userInfo.userNickname = @"test2";
    
    return userInfo;
}

- (NSArray <RedpacketUserInfo *>*)groupMembers
{
    RedpacketUserInfo *userInfo2 = [RedpacketUserInfo new];
    userInfo2.userId = @"test2";
    userInfo2.userNickname = @"test2";

    RedpacketUserInfo *userInfo3 = [RedpacketUserInfo new];
    userInfo3.userId = @"test3";
    userInfo3.userNickname = @"test3";
    
    RedpacketUserInfo *userInfo4 = [RedpacketUserInfo new];
    userInfo4.userId = @"test4";
    userInfo4.userNickname = @"test4";
    
    return @[userInfo2, userInfo3, userInfo4];
}

- (RedpacketUserInfo *)userInfo
{
    if (_isTest1)
        return self.userTest1Info;
    else
        return self.userTest2Info;
}


#pragma mark -

- (void)initRedpacketInfo
{
    [YZHRedpacketBridge sharedBridge].delegate = self;
    [YZHRedpacketBridge sharedBridge].dataSource = self;
    [YZHRedpacketBridge sharedBridge].isDebug = YES;
}

- (void)initRedpacketSend
{
    /**
     红包功能的控制器， 产生用户单击红包后的各种动作
     */
    _viewControl = [[RedpacketViewControl alloc] init];
    /**
     *  获取群组用户代理
     */
    _viewControl.delegate = self;
    //  需要当前的聊天窗口
    _viewControl.conversationController = self;
    //  需要当前聊天窗口的会话ID
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    
    userInfo.userId = @"123123";
    
    _viewControl.converstationInfo = userInfo;
    
    __weak typeof(self) weakSelf = self;
    
    //  用户抢红包和用户发送红包的回调
    [_viewControl setRedpacketGrabBlock:^(RedpacketMessageModel *messageModel) {
        //  发送通知到发送红包者处
//        [weakSelf sendRedpacketHasBeenTaked:messageModel];
        
    } andRedpacketBlock:^(RedpacketMessageModel *model) {
        //  发送红包
//        [weakSelf sendRedPacketMessage:model];
        
        weakSelf.redpacketModel = model;
    }];
     
}

- (void)getGroupMemberListCompletionHandle:(void (^)(NSArray<RedpacketUserInfo *> *))completionHandle
{
    completionHandle([self groupMembers]);
}

- (RedpacketUserInfo *)redpacketUserInfo
{
    return self.userInfo;
}


- (void)loadUser
{
    NSString *userId = self.userInfo.userId;
    if([[YZHRedpacketBridge sharedBridge] isNeedUpdateSignWithUserId:userId]) {
        if (userId) {
            
            // 获取应用自己的签名字段。实际应用中需要开发者自行提供相应在的签名计算服务
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl, userId];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [[[AFHTTPRequestOperationManager manager] HTTPRequestOperationWithRequest:request
                                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                                      [self configWithSignDict:responseObject];
                                                                                  }
                                                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                  NSLog(@"request redpacket sign failed:%@", error);
                                                                              }] start];
        }
    }
}

- (void)configWithSignDict:(NSDictionary *)dict
{
    NSString *partner = [dict stringValueForKey:@"partner"];
    NSString *appUserId = [dict stringValueForKey:@"user_id"];
    NSString *timeStamp = [dict stringValueForKey:@"timestamp"];
    NSString *sign = [dict stringValueForKey:@"sign"];
    
    
    [[YZHRedpacketBridge sharedBridge] configWithSign:sign
                                              partner:partner
                                            appUserId:appUserId
                                            timestamp:timeStamp];
}


#pragma mark -

- (void)redpacketError:(NSString *)error withErrorCode:(NSInteger)code
{

    
}

@end



