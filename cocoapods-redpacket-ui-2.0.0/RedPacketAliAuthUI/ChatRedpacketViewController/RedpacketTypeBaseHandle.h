//
//  RedpacketTypeBaseHandle.h
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/12.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPRedpacketModel.h"
#import "UIView+YZHPrompting.h"
#import "RPRedpacketTool.h"
#import "RPRedpacketPreView.h"
@protocol RedpacketHandleDelegate <NSObject>

//  拆红包
- (void)sendGrabRedpacketRequest:(RPRedpacketModel *)messageModel;

//  广告红包处理事件
- (void)advertisementRedPacketAction:(RPAdvertInfo *)advertInfo;

@end


@interface RedpacketTypeBaseHandle : NSObject

@property (nonatomic,strong)RPRedpacketModel * messageModel;
@property (nonatomic,strong)NSDictionary * redpacketDetailDic;
@property (nonatomic,weak)NSObject <RedpacketHandleDelegate> * delegate;
@property (nonatomic,weak)UIViewController * fromViewController;

+ (void)handleWithMessageModel:(RPRedpacketModel *)messageModel
                       success:(void(^)(RedpacketTypeBaseHandle * handle))successblock
                       failure:(void(^)(NSString *errorMsg,NSInteger errorCode))failureBlock;

- (void)showRedPacketDetailViewController:(RPRedpacketModel *)messageModel;

//  获取红包详情
- (void)getRedpacketDetail;

@end


@interface RedpacketTypeBaseHandle(infoView)

- (void)setingPacketViewWith:(RPRedpacketModel *)messageModel
               boxStatusType:(RedpacketBoxStatusType)BoxStatusType
            closeButtonBlock:(void (^)(RPRedpacketPreView * packetView))closeButtonBlock
           submitButtonBlock:(void(^)(RedpacketBoxStatusType boxStatusType,RPRedpacketPreView * packetView))submitButtonBlock;
- (void)removeRedPacketView;
- (void)removeRedPacketView:(BOOL)animated;
- (void)popSubView:(UIView *)view;

@end
