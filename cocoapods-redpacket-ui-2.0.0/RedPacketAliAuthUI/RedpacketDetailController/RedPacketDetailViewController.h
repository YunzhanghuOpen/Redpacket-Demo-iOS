//
//  RedPacketDetailViewController.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/28.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPRefreshTableViewController.h"
#import "RPRedpacketModel.h"

@interface RedPacketDetailViewController : RPRefreshTableViewController

@property (nonatomic, strong)   RPRedpacketModel *messageModel;

@end
