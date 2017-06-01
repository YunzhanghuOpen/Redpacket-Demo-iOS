//
//  RPDetailViewContrroller.h
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/7.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPBaseViewController.h"
#import "RPRedpacketModel.h"


@interface RPAdvertisementDetailViewContrroller : RPBaseViewController

@property (nonatomic, weak) RPRedpacketModel *messageModel;
@property (nonatomic, copy) void(^advertisementDetailAction)(RPAdvertInfo *adverInfo);

@end
