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
#import "RedpacketDefines.h"
#import "RPRedpacketUnionHandle.h"
#import "RPRedpacketModel.h"
#import "RPAdvertInfo.h"

static NSString *kRedpacketsSaveKey     = @"redpacketSaveKey";
static NSString *kRedpacketGroupSaveKey = @"redpacketGroupSaveKey";


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
    
    UIBarButtonItem *changeUserItem = [[UIBarButtonItem alloc] initWithTitle:@"切换用户" style: UIBarButtonItemStyleDone target:self action:@selector(userChangeItemClick)];
    self.navigationItem.rightBarButtonItem = changeUserItem;
}

/** 发红包页面 */
- (void)presentRedpacketViewController:(RPRedpacketControllerType)controllerType
{
    [self presentRedpacketViewController:controllerType
                isSupportMemberRedpacket:NO];
}

/** 发红包页面（支持定向红包） */
- (void)presentRedpacketViewController:(RPRedpacketControllerType)controllerType
              isSupportMemberRedpacket:(BOOL)isSupport
{
    RPUserInfo *userInfo = [RPUserInfo new];
    
    NSInteger groupCount = 0;
    if (_isGroup) {
        
        //  当前群会话ID
        userInfo.userID = @"#ConveritionID#";
        groupCount = [RedpacketUser currentUser].users.count;
        
    }else {
        
        UserInfo *talkingUser = [RedpacketUser currentUser].talkingUserInfo;
        userInfo.userID = talkingUser.userId;
        userInfo.avatar = talkingUser.userAvatarURL;
        userInfo.userName = talkingUser.userNickName;
        
    }
    
    __weak typeof(self) weakSelf = self;
    /** 发红包成功*/
    RedpacketSendBlock sendSuccessBlock = ^(RPRedpacketModel *model) {
        
        NSDictionary *redpacket = @{@"1":[RPRedpacketUnionHandle dictWithRedpacketModel:model isACKMessage:NO]};    //  1代表红包消息
        [weakSelf.mutDatas addObject:redpacket];
        [weakSelf.talkTableView reloadData];
        
    };
    
    /** 定向红包获取群成员列表, 如果不需要指定接收人，可以传nil */
    RedpacketMemberListBlock memeberListBlock;
    if(controllerType == RPRedpacketControllerTypeGroup && isSupport) {
        
        memeberListBlock = ^(RedpacketMemberListFetchBlock completionHandle) {
            
            NSMutableArray <RPUserInfo *> *groupInfos = [NSMutableArray array];
            for (UserInfo *userInfo in [RedpacketUser currentUser].users) {
                
                RPUserInfo *user = [RPUserInfo new];
                user.userID = userInfo.userId;
                user.userName = userInfo.userNickName;
                user.avatar = userInfo.userAvatarURL;
                [groupInfos addObject:user];
            }
            
            completionHandle(groupInfos);
        };
    } else {
        memeberListBlock = nil;
    }
    
    [RedpacketViewControl presentRedpacketViewController:controllerType
                                         fromeController:self groupMemberCount:groupCount
                                   withRedpacketReceiver:userInfo
                                         andSuccessBlock:sendSuccessBlock withFetchGroupMemberListBlock:memeberListBlock];
    
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
        
        [self redpacketTouched:redpacketDic];
        
    }else {
        return;
    }
    
}

/** 抢红包 */
- (void)redpacketTouched:(NSDictionary *)redpacketDic
{
    RPRedpacketModel *model = [RPRedpacketUnionHandle modelWithChannelRedpacketDic:redpacketDic andSender:nil];
    __weak typeof(self) weakSelf = self;
    [RedpacketViewControl redpacketTouchedWithMessageModel:model fromViewController:self redpacketGrabBlock:^(RPRedpacketModel *messageModel) {
        /** 抢红包成功, 转账成功的回调*/
        NSDictionary *redpacket = @{@"2": [RPRedpacketUnionHandle dictWithRedpacketModel:model isACKMessage:YES]};    //  2代表红包被抢的消息
        [weakSelf.mutDatas addObject:redpacket];
        [weakSelf.talkTableView reloadData];
    } advertisementAction:^(id info) {
        [weakSelf advertisementAction:info];
    }];
}

- (void)advertisementAction:(id)args
{
#ifdef AliAuthPay
    /** 营销红包事件处理*/
    RPAdvertInfo *adInfo  =args;
    switch (adInfo.AdvertisementActionType) {
        case RedpacketAdvertisementReceive:
            /** 用户点击了领取红包按钮*/
            break;
            
        case RedpacketAdvertisementAction: {
            /** 用户点击了去看看按钮，进入到商户定义的网页 */
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:adInfo.shareURLString]];
            [webView loadRequest:request];
            
            UIViewController *webVc = [[UIViewController alloc] init];
            [webVc.view addSubview:webView];
            [(UINavigationController *)self.presentedViewController pushViewController:webVc animated:YES];
            
        }
            break;
            
        case RedpacketAdvertisementShare: {
            /** 点击了分享按钮，开发者可以根据需求自定义，动作。*/
            [[[UIAlertView alloc]initWithTitle:nil
                                       message:@"点击「分享」按钮，红包SDK将该红包素材内配置的分享链接传递给商户APP，由商户APP自行定义分享渠道完成分享动作。"
                                      delegate:nil
                             cancelButtonTitle:@"我知道了"
                             otherButtonTitles:nil] show];
        }
            break;
            
        default:
            break;
    }
#else
    NSDictionary *dict =args;
    NSInteger actionType = [args[@"actionType"] integerValue];
    switch (actionType) {
        case 0:
            // 点击了领取红包
            break;
        case 1: {
            // 点击了去看看按钮，此处为演示
            UIViewController     *VC = [[UIViewController alloc]init];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
            [VC.view addSubview:webView];
            NSString *url = args[@"LandingPage"];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [webView loadRequest:request];
            [(UINavigationController *)self.presentedViewController pushViewController:VC animated:YES];
        }
            break;
        case 2: {
            // 点击了分享按钮，开发者可以根据需求自定义，动作。
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"点击「分享」按钮，红包SDK将该红包素材内配置的分享链接传递给商户APP，由商户APP自行定义分享渠道完成分享动作。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
#endif
}


@end
