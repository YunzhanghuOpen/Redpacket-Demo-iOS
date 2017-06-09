//
//  RedpacketViewControl.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RPRedpacketModel.h"


typedef NS_ENUM(NSInteger,RPRedpacketControllerType){
    
    RPRedpacketControllerTypeSingle,    //点对点红包
    RPRedpacketControllerTypeRand,      //小额度随机红包
    RPRedpacketControllerTypeGroup,     //群红包
    
};


// 发红包成功后的回调， MessageModel红包相关的数据，发红包者信息，收红包者信息，抢到的红包金额
typedef void(^RedpacketSendBlock)(RPRedpacketModel *model);
// 抢红包成功后的回调
typedef void(^RedpacketGrabBlock)(RPRedpacketModel *messageModel);
// 广告红包事件回调
typedef void(^RedpacketAdvertisementActionBlock)(RPAdvertInfo *info);

// 开发者查询群组成员列表成功后， 通过此Block回调给SDK
typedef void(^RedpacketMemberListFetchBlock)(NSArray<RPUserInfo *> *groupMemberList);
// 获取定向红包，群成员列表的回调
typedef void(^RedpacketMemberListBlock)(RedpacketMemberListFetchBlock fetchFinishBlock);


@interface RedpacketViewControl : NSObject

// 生成红包的方法和回调
+ (void)presentRedpacketViewController:(RPRedpacketControllerType)controllerType            //  红包类型
                       fromeController:(UIViewController *)fromeController                  //  要展示红包界面的控制器
                      groupMemberCount:(NSInteger)count                                     //  群成员人数，可以为0
                 withRedpacketReceiver:(RPUserInfo *)receiver                               //  单聊红包红包接收者相关信息， 群聊红包只传群ID
                       andSuccessBlock:(RedpacketSendBlock)sendBlock                        //  发送红包成功后的回调（红包生成成功后，开发者将此红包数据通过响应的数据通道传给对应的接收人或者群）
         withFetchGroupMemberListBlock:(RedpacketMemberListBlock)memberBlock;                //  定向红包获取群成员列表的回调

// 抢红包的方法和事件回调
+ (void)redpacketTouchedWithMessageModel:(RPRedpacketModel *)model                          //  红包相关信息(发红包成功后会产生一个消息体，有这个消息体转换而来)
                      fromViewController:(UIViewController *)fromViewController             //  要展示红包界面的控制器
                      redpacketGrabBlock:(RedpacketGrabBlock)grabTouch                      //  抢红包成功后的回调
                     advertisementAction:(RedpacketAdvertisementActionBlock)advertisementAction; //  广告红包的事件回调


// 红包记录页面
+ (void)presentChangePocketViewControllerFromeController:(UIViewController *)viewController;


@end
