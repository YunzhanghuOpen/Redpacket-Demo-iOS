//
//  RedpacketBaseTableViewController.h
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedpacketBaseTableViewController : UIViewController <
                                                                UITableViewDelegate,
                                                                UITableViewDataSource
                                                                >

@property (nonatomic, assign)          BOOL             isGroup;
@property (nonatomic, strong) IBOutlet UITableView      *talkTableView;
@property (nonatomic, strong)          NSMutableArray   *mutDatas;

+ (instancetype)controllerWithControllerType:(BOOL)isGroup;

@end
