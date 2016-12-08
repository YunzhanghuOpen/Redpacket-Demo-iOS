//
//  RedpacketUser.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketUser.h"

#define RedpacketSenderID       @"redpacketSenderId"
#define RedpacketReceiverID     @"redpacketReceiverId"


@implementation UserInfo

+ (UserInfo *)configWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                 andUserAvatar:(NSString *)userAvatar
                 andUserAvatarURL:(NSString *)userAvatarURL
{
    UserInfo *info = [UserInfo new];
    info.userId = userId;
    info.userAvatar = userAvatar;
    info.userNickName = userName;
    info.userAvatarURL = userAvatarURL;
    return info;
}

@end


@interface RedpacketUser ()


@end


@implementation RedpacketUser
@synthesize users = _users;


+ (RedpacketUser *)currentUser
{
    static RedpacketUser *__current_user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __current_user = [RedpacketUser new];
    });

    return __current_user;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self readParamers];
    }

    return self;
}

- (void)saveParamSenderID:(NSString *)senderID
            andReceiverID:(NSString *)receiverID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (senderID.length && receiverID.length) {
        [defaults setValue:senderID forKey:RedpacketSenderID];
        [defaults setValue:receiverID forKey:RedpacketReceiverID];
    }else {
        [defaults removeObjectForKey:RedpacketSenderID];
        [defaults removeObjectForKey:RedpacketReceiverID];
    }
    
    [defaults synchronize];
}

- (void)readParamers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *senderId = [defaults valueForKey:RedpacketSenderID];
    NSString *receiverId = [defaults valueForKey:RedpacketReceiverID];
    
    if (senderId && receiverId) {
        [self loginWithSender:senderId
                  andReceiver:receiverId];
    }
}

- (void)loginOut
{
    _users = nil;
    _userInfo = nil;
    _talkingUserInfo = nil;
    
    [self saveParamSenderID:@""
              andReceiverID:@""];
    
}

- (void)loginWithSender:(NSString *)senderID
            andReceiver:(NSString *)receiverID
{
    if (!(senderID && receiverID)) {
        return;
    }
    
    UserInfo *senderUser = [UserInfo configWithUserId:senderID
                                             userName:senderID
                                        andUserAvatar:@"UserHeader_user1.jpg"
                            andUserAvatarURL:@"http://files.parsetfss.com/9346bbf1-a67c-404d-9456-78ba9f83de5f/tfss-2fc1576f-c9b3-4ac7-969a-15ea4582d6b9-image.png"];
    
    UserInfo *receiverUser = [UserInfo configWithUserId:receiverID
                                               userName:receiverID
                                          andUserAvatar:@"UserHeader_user2.jpg"
                              andUserAvatarURL:@"http://files.parsetfss.com/9346bbf1-a67c-404d-9456-78ba9f83de5f/tfss-41bd8753-8d4e-480f-b5a3-a3207a74239e-image.png"];
    
    if (!_users) {
        _users = [@[] mutableCopy];
    }
    
    [_users addObject:senderUser];
    [_users addObject:receiverUser];
    
    _userInfo = self.users[0];
    _talkingUserInfo = self.users[1];
    
    [self saveParamSenderID:senderID
              andReceiverID:receiverID];
    
}

- (void)changeUserBetweenUser1AndUser2
{
    if ([_userInfo.userId isEqualToString:self.users[1].userId]) {
        
        _userInfo = self.users[0];
        _talkingUserInfo = self.users[1];
        
    }else {
        
        _userInfo = self.users[1];
        _talkingUserInfo = self.users[0];
        
    }
}

@end
