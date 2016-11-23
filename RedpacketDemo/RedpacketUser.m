//
//  RedpacketUser.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketUser.h"

@implementation UserInfo

+ (UserInfo *)configWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                 andUserAvatar:(NSString *)userAvatar
{
    UserInfo *info = [UserInfo new];
    info.userId = userId;
    info.userAvatar = userAvatar;
    info.userNickName = userName;

    return info;
}

@end


@interface RedpacketUser ()



@end


@implementation RedpacketUser

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
        
        _userInfo = self.users[0];
        _talkingUserInfo = self.users[1];
        
    }

    return self;
}

- (void)changeUserWithUser1
{
    _userInfo = self.users[0];
}


- (void)changeUserWithUser2
{
   _userInfo = self.users[1];
    
}

- (void)changeUserWithUser3
{
   _userInfo = self.users[2];
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

- (NSArray <UserInfo *> *)users
{
    UserInfo *user1 = [UserInfo configWithUserId:@"test1" userName:@"user1" andUserAvatar:@"UserHeader_user1.jpg"];
    UserInfo *user2 = [UserInfo configWithUserId:@"test2" userName:@"user2" andUserAvatar:@"UserHeader_user2.jpg"];
    UserInfo *user3 = [UserInfo configWithUserId:@"user3" userName:@"user3" andUserAvatar:@""];
    
    return @[
             user1,
             user2,
             user3
            ];
}
@end
