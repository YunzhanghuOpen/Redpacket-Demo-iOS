//
//  RPReceiptsViewController.h
//  RedpacketLib
//
//  Created by 都基鹏 on 2016/12/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPRefreshTableViewController.h"
#import "RPRedpacketModel.h"
#import "RPMyIncomeRedPacketCell.h"

@interface RPReceiptsInAlipayViewController : RPRefreshTableViewController

@property (nonatomic, strong) RPPersonalRedpacketInfo *personalRedpacketInfo;
@property (nonatomic, assign) RPPersonalRedpacketType personalRedpacketType;

- (void)closeBarButtonSender;
- (void)requestRedpacketGetDetailReplacer;
- (void)requestRedpacketGetDetail;
- (NSArray *)currentRedpackets;

@end
