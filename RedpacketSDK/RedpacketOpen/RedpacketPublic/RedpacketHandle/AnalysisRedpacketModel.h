//
//  AnalysisRedpacketModel.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yan on 2017/5/11.
//  Copyright © 2017年 Mr.Yan. All rights reserved.
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

@property (nonatomic, assign, readonly) MessageCellType type;

@property (nonatomic, assign, readonly) BOOL isSender;

/* 红包类型 */
@property (nonatomic, assign, readonly) RPRedpacketType redpacketType;

/* 红包cell展示语句 */
@property (nonatomic,   copy, readonly) NSString *greeting;

@property (nonatomic,   copy, readonly) NSString *redpacketOrgName;

@property (nonatomic, strong)   RPUser *sender;
@property (nonatomic, strong)   RPUser *receiver;

@end
