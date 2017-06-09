//
//  RedpacketSendControl.h
//  RedpacketLib
//
//  Created by Mr.Yang on 2016/10/17.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RPRedpacketModel.h"


typedef void (^RedpacketSendSccessBlock)(id object);

@interface RPRedpacketSendControl : NSObject

@property (nonatomic, weak) UIViewController *hostViewController;

+ (instancetype)currentControl;

+ (void)releaseSendControl;

- (void)payMoney:(NSString *)money withMessageModel:(RPRedpacketModel *)model
                                       inController:(UIViewController *)viewController
                                    andSuccessBlock:(RedpacketSendSccessBlock)successBlock;

@end
