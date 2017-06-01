//
//  RPReceiptsViewController.m
//  RedpacketLib
//
//  Created by 都基鹏 on 2016/12/20.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RPReceiptsInAlipayViewController.h"
#import "RPReceiotsInAlipayHeaderView.h"
#import "RPReceiotsInAlipayEmptyTableViewCell.h"
#import "RPAlipayAuth.h"
#import "RPRedpacketBridge.h"
#import "RedpacketErrorView.h"
#import "RPRedpacketSetting.h"
#import "AlipaySDK.h"

static NSInteger pageSize = 12;

@interface RPReceiptsInAlipayViewController ()<RPReceiotsInAlipayHeaderViewDelegate,UIActionSheetDelegate>

@property (nonatomic,copy)  NSString            *username;
@property (nonatomic,weak)  RedpacketErrorView  *retryViw;

@end

@implementation RPReceiptsInAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLable.text            = @"收到的红包";
    self.view.backgroundColor       = [UIColor whiteColor];
    self.tableView.backgroundColor  = [UIColor whiteColor];
    
    [self.tableView registerClass:[RPMyIncomeRedPacketCell class] forCellReuseIdentifier:@"RPMyIncomeRedPacketCell"];
    [self.tableView registerClass:[RPReceiotsInAlipayHeaderView class] forCellReuseIdentifier:@"RPMyIncomeHeaderView"];
    
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.showRefreshFooter          = YES;
    
    self.personalRedpacketType      = RPPersonalRedpacketTypeReceive;
    [self removebindingAliauth:NO];
    [self addCloseBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavgationBarBackgroundColor:[RedpacketColorStore rp_textColorRed]
                              titleColor:[RedpacketColorStore rp_textcolorYellow]
                         leftButtonTitle:nil
                        rightButtonTitle:@"我的红包"];
}

- (void)closeBarButtonSender
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickButtonRight
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"收到的红包",@"发出的红包", nil];
    [actionSheet showInView:self.view];
}

- (void)removebindingAliauth:(BOOL)removeBinding {
    rpWeakSelf;
    [weakSelf.view rp_showHudWaitingView:YZHPromptTypeWating];
    if (removeBinding) {
        [RPRedpacketAliauth unBindAliAuth:^(NSError *error) {
            [weakSelf.view rp_removeHudInManaual];
            if (!error) {
                weakSelf.username = nil;
                [weakSelf requestRedpacketGetDetailReplacer];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.view rp_showHudErrorView:error.localizedDescription];
            }
        }];
    } else {
        [RPRedpacketAliauth fetchAliAuthBindInfo:^(NSError *error, NSString *string) {
            [weakSelf.view rp_removeHudInManaual];
            if (!error) {
                weakSelf.username = string;
                [weakSelf requestRedpacketGetDetailReplacer];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.view rp_showHudErrorView:error.localizedDescription];
            }
        }];
    }
}

- (void)refreshTitle {
    self.subLable.text = [NSString stringWithFormat:@"%@红包服务", [RPRedpacketSetting shareInstance].redpacketOrgName];
    [self.tableView reloadData];
}

- (void)addCloseBarButtonItem {
    if (self.navigationController.viewControllers.count == 1) {//如果为为非push页面，则显示关闭按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[RedpacketColorStore rp_textcolorYellow] forState:UIControlStateNormal];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeBarButtonSender) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex) {
            self.personalRedpacketType = RPPersonalRedpacketTypeSend;
            self.titleLable.text = @"发出的红包";
            if (self.personalRedpacketInfo.sendRedpackets.count == 0) {
                [self requestRedpacketGetDetail];
            } else {
                if (self.personalRedpacketInfo.sendRedpackets.count < self.personalRedpacketInfo.totalSendCount) {
                    self.showRefreshFooter = YES;
                } else {
                    self.showRefreshFooter = NO;
                }
            }
            [self.tableView reloadData];
        } else {
            self.personalRedpacketType = RPPersonalRedpacketTypeReceive;
            self.titleLable.text = @"收到的红包";
            if (self.personalRedpacketInfo.receiveRedpackets.count < self.personalRedpacketInfo.totalReceiveCount) {
                self.showRefreshFooter = YES;
            } else {
                self.showRefreshFooter = NO;
            }
            [self.tableView reloadData];
            
        }
    }
}

- (void)requestRedpacketGetDetailReplacer
{
    [self requestRedpacketGetDetail];
}

- (void)requestRedpacketGetDetail
{
    [self.view rp_showHudWaitingView:YZHPromptTypeWating];
    rpWeakSelf;
    [RPRedpacketStatistics fetchPersonalRedpacketInfos:weakSelf.personalRedpacketType
                                      fromPersonalInfo:weakSelf.personalRedpacketInfo
                                                legnth:pageSize
                                        andFinishBlock:^(NSError *error, RPPersonalRedpacketInfo *personalInfo) {
        [weakSelf.view rp_removeHudInManaual];
        if (!error) {
            [weakSelf.view rp_removeHudInManaual];
            [weakSelf.retryViw removeFromSuperview];
            [weakSelf handleHistoryPersonalInfo:personalInfo];
            [weakSelf tableViewDidFinishTriggerHeader:NO reload:YES];
        } else {
            if (error.code == NSIntegerMax) {
                NSArray *redpackets = nil;
                if (weakSelf.personalRedpacketType == RPPersonalRedpacketTypeSend) {
                    redpackets = personalInfo.sendRedpackets;
                }else {
                    redpackets = personalInfo.receiveRedpackets;
                }
                if (redpackets.count < 1) {
                    
                    [weakSelf.view rp_removeHudInManaual];
                    [weakSelf LoadretryView];
                    
                }else{
                    [weakSelf.view rp_showHudErrorView:error.localizedDescription];
                }
            }else {
                [weakSelf.view rp_showHudErrorView:error.localizedDescription];
            }
        }
    }];
}

- (void)handleHistoryPersonalInfo:(RPPersonalRedpacketInfo *)personalInfo
{
    self.personalRedpacketInfo = personalInfo;
    if (self.personalRedpacketType == RPPersonalRedpacketTypeReceive) {
        if (personalInfo.receiveRedpackets.count == 0) {
            self.showRefreshFooter = NO;
            return;
        }
        if (personalInfo.receiveRedpackets.count == personalInfo.totalReceiveCount) {
            self.showRefreshFooter = NO;
        }else {
            self.showRefreshFooter = YES;
        }
    }else {
        if (personalInfo.sendRedpackets == 0) {
            self.showRefreshFooter = NO;
            return;
        }
        if (personalInfo.sendRedpackets.count == personalInfo.totalSendCount) {
            self.showRefreshFooter = NO;
        }else {
            self.showRefreshFooter = YES;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *redpackets = [self currentRedpackets];
    return section?(self.personalRedpacketType == RPPersonalRedpacketTypeSend?redpackets.count:(redpackets.count?:1)):1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section?58.0f:(self.personalRedpacketType == RPPersonalRedpacketTypeSend?282:(self.username.length?344:373));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        
        if ([self currentRedpackets].count) {
            
            RPMyIncomeRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPMyIncomeRedPacketCell" forIndexPath:indexPath];
            
            if (self.personalRedpacketType == RPPersonalRedpacketTypeReceive) {
                
                cell.briefReceiveInfo = [self currentRedpackets][indexPath.row];
                
            } else {
                
                cell.briefSendInfo = [self currentRedpackets][indexPath.row];
                
            }
            
            return cell;
            
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RPReceiotsInAlipayEmptyTableViewCell"];
            
            if (!cell) {
                
                cell = [RPReceiotsInAlipayEmptyTableViewCell new];
                
            }
            
            return cell;
            
        }
        
    }else {
        
        RPReceiotsInAlipayHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:@"RPReceiotsInAlipayHeaderView"];
        
        if (!cell) {
            
            cell = [[RPReceiotsInAlipayHeaderView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RPReceiotsInAlipayHeaderView"];
            
        }
        
        cell.delegate = self;
        cell.personalRedpacketType = self.personalRedpacketType;
        cell.username = self.username;
        cell.personalRedpacketInfo = self.personalRedpacketInfo;
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSArray *)currentRedpackets
{
    NSArray *redpackets = nil;
    
    if (self.personalRedpacketType == RPPersonalRedpacketTypeSend) {
        
        redpackets = self.personalRedpacketInfo.sendRedpackets;
        
    }else {
        
        redpackets = self.personalRedpacketInfo.receiveRedpackets;
        
    }
    
    return redpackets;
}

- (void)tableViewDidTriggerFooterRefresh
{
    [self requestRedpacketGetDetail];
}

#pragma mark - other

- (RedpacketErrorView *)retryViw
{
    rpWeakSelf;
    if (!_retryViw) {
        _retryViw = [RedpacketErrorView viewWithWith:self.view.bounds.size.width];
        
        [_retryViw setButtonClickBlock:^{
            
            [weakSelf requestRedpacketGetDetail];
            
        }];
        
    }
    return _retryViw;
}

- (void)LoadretryView
{
    [self.view insertSubview:self.retryViw
                aboveSubview:self.tableView];
    self.retryViw.frame = self.view.bounds;
}


- (void)doAlipayAuth {
    static RPAlipayAuth *staticAuth = nil;
    staticAuth = [RPAlipayAuth new];
    [self.view rp_showHudWaitingView:YZHPromptTypeWating];
    rpWeakSelf;
    
    [staticAuth doAlipayAuth:^(BOOL isSuccess, NSString *error) {
        
        staticAuth = nil;
        [weakSelf.view rp_removeHudInManaual];
        
        if (isSuccess) {
            
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                        message:@"已成功绑定支付宝账号，以后红包收到的钱会自动入账到此支付宝账号。"
                                       delegate:nil
                              cancelButtonTitle:@"我知道了"
                              otherButtonTitles:nil] show];
            
            [weakSelf removebindingAliauth:NO];
            
        }else {
            
            [weakSelf.view rp_showHudErrorView:error];
            
        }
        
    }];
}

- (void)removeBinding {
    [self removebindingAliauth:YES];
}

@end

