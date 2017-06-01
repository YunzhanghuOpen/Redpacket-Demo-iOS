//
//  RPAdvertisementDetailView.h
//  RedpacketLib
//
//  Created by 都基鹏 on 16/9/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPRedpacketModel.h"


@protocol RPAdvertisementDetailViewDelegate <NSObject>

//点击领取红包
- (void)getRedpacket;
- (void)advertisementRedPacketAction:(RPAdvertInfo *)advertInfo;

@end


@interface RPAdvertisementDetailView : UIScrollView

@property (nonatomic, strong) RPRedpacketModel * detailModel;
@property (nonatomic,   weak) id<RPAdvertisementDetailViewDelegate> rpDelegate;

@end
