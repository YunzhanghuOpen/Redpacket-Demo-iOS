//
//  RPRefreshTableViewController.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/9.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPBaseViewController.h"
#import "RPRedpacketViews.h"


#define KCELLDEFAULTHEIGHT 50

@interface RPRefreshTableViewController : RPBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_rightItems;
}

@property (strong, nonatomic) NSArray *rightItems;
@property (strong, nonatomic) UIView *defaultFooterView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic) int page;

@property (nonatomic) BOOL showRefreshHeader;//是否支持下拉刷新
@property (nonatomic) BOOL showRefreshFooter;//是否支持上拉加载

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;//下拉刷新事件
- (void)tableViewDidTriggerFooterRefresh;//上拉加载事件

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
