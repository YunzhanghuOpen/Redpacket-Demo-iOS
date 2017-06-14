//
//  RedpacketConfig1.h
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/10/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RedpacketViewControl.h"


/** 发送红包消息回调*/
typedef void(^RedpacketSendPacketBlock)(NSDictionary *dict);
/** 抢红包成功回调*/
typedef void(^RedpacketGrabPacketBlock)(NSDictionary *dict);


@class RedpacketUserInfo;

@interface RedpacketConfig : NSObject

+ (RedpacketConfig *)sharedConfig;

@end


@interface RedpacketConfig (RedpacketControllers)

- (UITableViewCell *)cellForRedpacketMessageDict:(NSDictionary *)dict;

- (CGFloat)heightForRedpacketMessageDict:(NSDictionary *)dict;

@end
