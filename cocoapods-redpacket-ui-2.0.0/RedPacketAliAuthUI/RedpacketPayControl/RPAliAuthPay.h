//
//  RPAliAuthPay.h
//  RedpacketLib
//
//  Created by Mr.Yang on 2016/12/19.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RPRedpacketManager.h"


typedef void(^PaySuccessBlock)(NSString *billRef);

//  处理支付宝付款
@interface RPAliAuthPay : NSObject

- (void)payMoney:(NSString *)payMoney inController:(UIViewController *)currentController
                                    andFinishBlock:(PaySuccessBlock)paySuccessBlock;

@end
