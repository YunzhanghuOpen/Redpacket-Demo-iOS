//
//  RPAlipayAuth.h
//  RedpacketLib
//
//  Created by Mr.Yang on 2016/12/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPRedpacketManager.h"


typedef void(^AlipayAuthCallBack)(BOOL isSuccess, NSString *error);

//  处理支付宝授权信息
@interface RPAlipayAuth : NSObject

- (void)doAlipayAuth:(AlipayAuthCallBack)callBack;

@end
