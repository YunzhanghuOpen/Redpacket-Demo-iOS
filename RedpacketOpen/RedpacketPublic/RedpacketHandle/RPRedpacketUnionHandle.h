//
//  RPRedpacketUnionHandle.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 2017/5/9.
//  Copyright © 2017年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPRedpacketModel.h"

//  红包状态
typedef NS_ENUM(NSInteger, MessageCellType) {
    
    MessageCellTypeRedpaket,        /***  红包消息*/
    MessageCellTypeRedpaketTaken,   /***  红包被抢消息*/
    MessageCellTypeUnknown          /***  未知消息*/
    
};


@interface RPUser : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;

@end


@interface AnalysisRedpacketModel : NSObject

+ (MessageCellType)messageCellTypeWithDict:(NSDictionary *)dict;

+ (AnalysisRedpacketModel *)analysisRedpacketWithDict:(NSDictionary *)dict
                                          andIsSender:(BOOL)isSender;

/* 红包消息类型 */
@property (nonatomic, assign, readonly) MessageCellType type;

@property (nonatomic, assign, readonly) BOOL isSender;

/* 红包类型 */
@property (nonatomic, assign, readonly) RPRedpacketType redpacketType;

/* 红包cell展示语句（祝福语） */
@property (nonatomic,   copy, readonly) NSString *greeting;

@property (nonatomic,   copy, readonly) NSString *redpacketOrgName;

@property (nonatomic, strong)   RPUser *sender;
@property (nonatomic, strong)   RPUser *receiver;

@end

@interface RPRedpacketUnionHandle : NSObject

//  生成通道中传输的Dict
+ (NSDictionary *)dictWithRedpacketModel:(RPRedpacketModel *)model
                            isACKMessage:(BOOL)isAckMessage;

//  IM通道中传入的Dict
+ (RPRedpacketModel *)modelWithChannelRedpacketDic:(NSDictionary *)redpacketDic
                                         andSender:(RPUserInfo *)sender;

@end
