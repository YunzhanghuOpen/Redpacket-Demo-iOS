//
//  RPMyIncomeRedPacketCell.h
//  RedpacketLib
//
//  Created by Mr.Yan on 2016/10/31.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRedpacketManager.h"

@interface RPMyIncomeRedPacketCell : UITableViewCell

//  红包记录类型
@property (nonatomic, assign) RPPersonalRedpacketType       personalRedpacketType;
//  发红包的每条记录
@property (nonatomic, strong) RPRedpacketBriefSendInfo      *briefSendInfo;
//  收红包的每条记录
@property (nonatomic, strong) RPRedpacketBriefReceiveInfo   *briefReceiveInfo;

@end
