//
//  RedpacketBaseTableViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/22.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketBaseTableViewController.h"
#import "RedpacketConfig.h"
#import "RedpacketUser.h"
#import "RedpacketMessageModel.h"
#import "RedpacketViewControl.h"
#import "RedpacketDefines.h"

static NSString *kRedpacketsSaveKey     = @"redpacketSaveKey";
static NSString *kRedpacketGroupSaveKey = @"redpacketGroupSaveKey";

@interface RedpacketBaseTableViewController () <RedpacketViewControlDelegate>

@end

@implementation RedpacketBaseTableViewController

+ (instancetype)controllerWithControllerType:(BOOL)isGroup
{
    RedpacketBaseTableViewController *controller = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    controller.isGroup = isGroup;
    
    return controller;
}

- (void)dealloc
{
    if (_mutDatas.count) {
        NSString *key = _isGroup ? kRedpacketGroupSaveKey   : kRedpacketsSaveKey;
        [[NSUserDefaults standardUserDefaults] setValue:_mutDatas forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.talkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.talkTableView.delegate = self;
    self.talkTableView.dataSource = self;
    
    NSString *key = _isGroup ? kRedpacketGroupSaveKey   : kRedpacketsSaveKey;
    
    _mutDatas = [[[NSUserDefaults standardUserDefaults] valueForKey:key] mutableCopy];
    if (!_mutDatas) {
        _mutDatas = [NSMutableArray array];
    }
    
    UIBarButtonItem *changeUserItem = [[UIBarButtonItem alloc] initWithTitle:@"切换用户" style:UIBarButtonItemStyleBordered target:self action:@selector(userChangeItemClick)];
    self.navigationItem.rightBarButtonItem = changeUserItem;
    
#pragma mark - Redpacket
    //  配置红包SDK相关参数
    
    //  当前聊天对象
    RedpacketUserInfo *conversionInfo = [[RedpacketUserInfo alloc] init];
    id <RedpacketViewControlDelegate> groupMemberDelegate = nil;
    
    if (_isGroup) {
        
        groupMemberDelegate = self;
        conversionInfo.userId = @"#ConveritionID#"; //  当前群聊会话ID
        
    }else {
        
        UserInfo *talkingUser = [RedpacketUser currentUser].talkingUserInfo;
        conversionInfo.userId = talkingUser.userId;
        conversionInfo.userAvatar = talkingUser.userAvatarURL;
        conversionInfo.userNickname = talkingUser.userNickName;
        
    }
    
    __weak typeof(self) weakSelf = self;
    [[RedpacketConfig sharedConfig] configViewControlWithCurrentController:self
                                                       viewControlDeleagte:groupMemberDelegate
                                                       currentConversation:conversionInfo
                                                        redpacketSendBlock:^(NSDictionary *dict) {
                                                            
                                                            /** 发红包成功*/
                                                            NSDictionary *redpacket = @{@"1": dict};    //  1代表红包消息
                                                            [weakSelf.mutDatas addObject:redpacket];
                                                            [weakSelf.talkTableView reloadData];
                                                            
                                                        } andRedpacketGrabBlock:^(NSDictionary *dict) {
                                                            
                                                            /** 抢红包成功, 转账成功的回调*/
                                                            NSDictionary *redpacket = @{@"2": dict};    //  2代表红包被抢的消息
                                                            [weakSelf.mutDatas addObject:redpacket];
                                                            [weakSelf.talkTableView reloadData];
                                                            
                                                        }];

#pragma mark - RedpacketEnd
}

#pragma mark - Redpacket
/** 定向红包获取群成员列表 */
- (void)getGroupMemberListCompletionHandle:(void (^)(NSArray<RedpacketUserInfo *> *))completionHandle
{
    NSMutableArray <RedpacketUserInfo *> *groupInfos = [NSMutableArray array];
    for (UserInfo *userInfo in [RedpacketUser currentUser].users) {
        
        RedpacketUserInfo *user = [RedpacketUserInfo new];
        user.userId = userInfo.userId;
        user.userNickname = userInfo.userNickName;
        user.userAvatar = userInfo.userAvatarURL;
        [groupInfos addObject:user];
    }
    
    completionHandle(groupInfos);

}

#pragma mark - Redpacket End

- (void)userChangeItemClick
{
    //  测试目的：切换只在User1和User2之间切换
    [[RedpacketUser currentUser] changeUserBetweenUser1AndUser2];
    
    self.title = [RedpacketUser currentUser].userInfo.userNickName;
    
    [self.talkTableView reloadData];
}

#pragma mark -
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (_mutDatas.count) {
        count = _mutDatas.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mutDatas.count == 0) {
        UITableViewCell *noneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        noneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        noneCell.textLabel.text = @"老板，请降下红包雨";
        
        return noneCell;
    }
    
    NSDictionary *dict = [_mutDatas objectAtIndex:indexPath.row];
    
    return [[RedpacketConfig sharedConfig] cellForRedpacketMessageDict:dict];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mutDatas.count == 0) {
        return 30.0f;
    }
    
    NSDictionary *dict = [_mutDatas objectAtIndex:indexPath.row];
    return [[RedpacketConfig sharedConfig] heightForRedpacketMessageDict:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mutDatas.count == 0) return;
    
    NSDictionary *dict = [_mutDatas objectAtIndex:indexPath.row];
    
    NSDictionary *redpacketDic = [dict valueForKey:@"1"];
    if (redpacketDic) {
        
        //  红包
        [[RedpacketConfig sharedConfig] grabRedpacket:redpacketDic];
        
    }else {
        
        return;
    }
    
}

@end
