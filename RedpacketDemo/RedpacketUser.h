//
//  RedpacketUser.h
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 演示用临时用户信息 */

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNickName;

+ (UserInfo *)configWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                 andUserAvatar:(NSString *)userAvatar;

@end

@interface RedpacketUser : NSObject

@property (nonatomic, strong)             UserInfo *userInfo;
@property (nonatomic, strong)             UserInfo *talkingUserInfo;
@property (nonatomic, strong, readonly)   NSArray <UserInfo *> *users;

+  (RedpacketUser *)currentUser;

- (void)changeUserWithUser1;
- (void)changeUserWithUser2;
- (void)changeUserWithUser3;

- (void)changeUserBetweenUser1AndUser2;

@end
