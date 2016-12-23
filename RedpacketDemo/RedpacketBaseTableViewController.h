//
//  RedpacketBaseTableViewController.h
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedpacketViewControl.h"

@interface RedpacketBaseTableViewController : UIViewController <
                                                                UITableViewDelegate,
                                                                UITableViewDataSource
                                                                >

@property (nonatomic, assign)          BOOL             isGroup;
@property (nonatomic, strong) IBOutlet UITableView      *talkTableView;
@property (nonatomic, strong)          NSMutableArray   *mutDatas;

+ (instancetype)controllerWithControllerType:(BOOL)isGroup;

/** 发红包页面 */
- (void)presentRedpacketViewController:(RPRedpacketControllerType)controllerType
              isSupportMemberRedpacket:(BOOL)isSupport;

- (void)presentRedpacketViewController:(RPRedpacketControllerType)controllerType;

@end
