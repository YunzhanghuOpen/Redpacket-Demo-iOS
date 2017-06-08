//
//  RedPacketDetailViewController.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/28.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketDetailViewController.h"
#import "RedpacketDetailCell.h"
#import "RedpacketColorStore.h"
#import "UIImageView+YZHWebCache.h"
#import "RPRedpacketBridge.h"
#import "RPRedpacketTool.h"
#import "RPRedpacketSetting.h"
#import "RPRedpacketManager.h"
#import "RPRedpacketDetailHeaderView.h"
#import "RPReceiptsInAlipayViewController.h"


@interface RedPacketDetailViewController ()

@property (nonatomic, strong) RPRedpacketDetailHeaderView   *headerView;
@property (nonatomic, strong) UILabel                       *describeLabel;


@end

@implementation RedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLable.text = @"红包";
    self.cuttingLineHidden = YES;
    [self addCloseBarButtonItem];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorInset  = UIEdgeInsetsZero;
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
    footer.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footer;
    
    [self clearBackBarButtonItemTitle];
    [self loadDetail];
}

- (void)tableViewDidTriggerFooterRefresh {
    [self loadDetail];
}

- (void)refreshTitle {
    self.subLable.text = [NSString stringWithFormat:@"%@红包服务", [RPRedpacketSetting shareInstance].redpacketOrgName];
}

- (void)setMessageModel:(RPRedpacketModel *)messageModel {
    _messageModel = messageModel;
    self.headerView.messageModel = messageModel;
}

- (void)loadDetail {
    rpWeakSelf;
    [RPRedpacketReceiver fetchRedpacketDetail:self.messageModel
                               userListLength:20
                                andFetchBlock:^(NSError *error, RPRedpacketModel *model) {
        weakSelf.messageModel = model;
        if (!error) {
            [weakSelf configWithRedpacketDetailDic:model];
            [weakSelf refreshTableContent:model.takenUsers];
            [weakSelf tableViewDidFinishTriggerHeader:NO reload:NO];
        } else {
            [weakSelf.view rp_showHudErrorView:error.localizedDescription];
        }
    }];
}

- (void)refreshTableContent:(NSArray<RPBriefUserInfo*> *)takenUsers
{
    self.showRefreshFooter = takenUsers.count == 20 ? YES : NO;
    if (takenUsers.count) {
        [self.tableView reloadData];
    }
}

    
- (void)configWithRedpacketDetailDic:(RPRedpacketModel *)model
{
    NSString *prompt = rpString(@"超过1天未被领取，金额%@元已退至您的支付宝账号",model.money);
    if (model.statusType == RPRedpacketStatusTypeOutDate && model.isSender && model.count != model.totalTakenCount) {
        if (model.redpacketType == RPRedpacketTypeSingle) {
            self.describeLabel.text = prompt;
        } else {
            self.describeLabel.text = rpString(@"该红包已过期，已领取%ld/%ld个，共%@/%@元",(long)model.totalTakenCount, (long)model.count,model.totalTakenMoney, model.money);
        }
    }else if(model.isSender) {
        if (model.redpacketType == RPRedpacketTypeSingle) {
            if (model.count == model.totalTakenCount) {
                self.describeLabel.text = rpString(@"%ld个红包，共%@元，已被对方领取", (long)model.count,model.money);
            }else {
                self.describeLabel.text = rpString(@"红包金额%@元，等待被领取", _messageModel.money);
            }
        }else {
            if (model.count == model.totalTakenCount) {
                self.describeLabel.text = rpString(@"%ld个红包共%@元， %@被抢光",(long)model.count,model.money, model.takenCostTime);
            }else {
                self.describeLabel.text = rpString(@"已领取%ld/%ld个，共%@/%@元",(long)model.totalTakenCount, (long)model.count ,model.totalTakenMoney, model.money);
            }
        }
    }else {
        if (model.redpacketType == RPRedpacketTypeGroupAvg ||
            model.redpacketType == RPRedpacketTypeSingle) {
            self.describeLabel.text = @"";
        }else {
            if (model.count == model.totalTakenCount) {
                self.describeLabel.text = rpString(@"%ld个红包，%@被抢光",(long)model.totalTakenCount, model.takenCostTime);
            }else{
                self.describeLabel.text = rpString(@"领取%ld/%ld个",(long)model.totalTakenCount,(long)model.count);
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - TabelViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        self.view.backgroundColor = [RedpacketColorStore rp_textColorRed];
    }else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, CGRectGetWidth(self.view.frame) - 15, 20)];
        _describeLabel.backgroundColor = [UIColor clearColor];
        _describeLabel.font            = [UIFont systemFontOfSize:12.0f];
        _describeLabel.textColor       = [RedpacketColorStore rp_textColorGray];
    }
    return _describeLabel;
}

#pragma mark - TableViewDelegate

static CGFloat rp_cellheight = 58.0f;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    
    if (_messageModel.redpacketType == RPRedpacketTypeGroupRand ||
        _messageModel.isSender) {
        
        [view addSubview:self.describeLabel];
        view.backgroundColor = [RedpacketColorStore rp_backGroundColor];
        
    }else{
        
        view.backgroundColor = [UIColor whiteColor];
        
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = [self footerHeight];
    UIView *view           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height)];
    view.backgroundColor   = [UIColor whiteColor];
    if ([_messageModel.receiveMoney floatValue] > 0.009) {
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看我的红包记录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[RedpacketColorStore rp_textColorBlue] forState:UIControlStateNormal];
        button.frame           = CGRectMake(0, height - 20, CGRectGetWidth(self.view.frame), 20);
        [button addTarget:self
                   action:@selector(myRedPacketDetailButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)footerHeight {
    NSInteger number;
    CGFloat headerHeight;
    if (_messageModel.isSender ||
        _messageModel.redpacketType == RPRedpacketTypeGroupRand) {
        number = [_messageModel.takenUsers count];
    }else {
        number = 0;
    }
    if ([_messageModel.receiveMoney floatValue] > 0.009) {
        headerHeight = 275;
    }else {
        headerHeight = 185;
    }
    // 40 为sectionHeader ， 15 为sectionFooter
    CGFloat height = CGRectGetHeight(self.view.frame) - number * rp_cellheight  - headerHeight - 15 - 40;
    height = height > 35 ? height : 35;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((_messageModel.redpacketType != RPRedpacketTypeGroupRand) &&
        (!_messageModel.isSender)){
        
        return 0;
        
    }
    
    return _messageModel.takenUsers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rp_cellheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RedpacketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedpacketDetailCellIdentifier"];
    
    if (!cell) {
        
        cell = [[RedpacketDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RedpacketDetailCellIdentifier"];
        
    }
    
    if (_messageModel.takenUsers.count > indexPath.row) {
        
        RPBriefUserInfo *currentUser = [_messageModel.takenUsers objectAtIndex:indexPath.row];
        cell.brifUserInfo = currentUser;
        
    }
    
    return cell;
}

- (void)myRedPacketDetailButtonClick
{
    RPReceiptsInAlipayViewController *myIncome;
    myIncome = [[RPReceiptsInAlipayViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:myIncome animated:YES];
}

#pragma mark - HeaderView

- (RPRedpacketDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[RPRedpacketDetailHeaderView alloc] init];
    }
    
    return _headerView;
}

- (void)addCloseBarButtonItem
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle       = UIBarStyleBlack;
    
    [self setNavgationBarBackgroundColor:[RedpacketColorStore rp_textColorRed]
                              titleColor:[RedpacketColorStore rp_textcolorYellow]
                         leftButtonTitle:@"关闭"
                        rightButtonTitle:nil];
    
}

- (void)clickButtonLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearBackBarButtonItemTitle
{
    //  左侧返回标题为空
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

@end
