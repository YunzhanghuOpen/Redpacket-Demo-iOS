//
//  RedpacketFucListViewController.m
//  RedpacketDemo
//
//  Created by Mr.Yang on 2016/11/18.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedpacketFucListViewController.h"
#import "RedpacketConfig.h"
#import "RedpacketViewControl.h"
#import "RedpacketUser.h"
#import "RedpacketSingleViewController.h"
#import "RedpacketGroupViewController.h"
#import "AboutMeViewController.h"
#import "RedpacketUserLoginViewController.h"


@interface RedpacketFucListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end

@implementation RedpacketFucListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = [RedpacketUser currentUser].userInfo.userNickName;
    
    [self showLoginViewController];
}

- (void)showLoginViewController
{
    if (![RedpacketUser currentUser].userInfo) {
        RedpacketUserLoginViewController *loginController = [[RedpacketUserLoginViewController alloc] initWithNibName:NSStringFromClass([RedpacketUserLoginViewController class]) bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableview.delegate         = self;
    self.tableview.dataSource       = self;
    
    self.tableview.scrollEnabled    = NO;
    self.tableview.bounces          = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(loginOutClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *userLoginOut = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = userLoginOut;
}

- (void)loginOutClicked
{
    [[RedpacketUser currentUser] loginOut];
    
    [self showLoginViewController];
}

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.functions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.autoresizingMask =   UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleHeight|
                                    UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin;
    
    titleLabel.frame = cell.contentView.frame;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    
    titleLabel.text = self.functions[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self invokeFunctionsAtIndex:indexPath.row];
}

- (void)invokeFunctionsAtIndex:(NSInteger)index
{
    static NSString *systemRedpacketInstruction = @"系统红包简介：\n系统红包以系统管理员的身份给用户发拼手气群红包，特别适合开发者们做运营活动使用。";
    static NSString *advertRedpacketInstruction = @"广告红包简介：\n广告红包使用云账户的商户端进行广告计划和品牌主红包素材配置，计划开始执行时，给符合条件的用户发放一个品牌红包，增加品牌曝光量。";
    
    UIViewController * controller = nil;
    
    switch (index) {
            
        case 0: controller = [RedpacketSingleViewController controllerWithControllerType:NO]; break;
            
        case 1: controller = [RedpacketGroupViewController controllerWithControllerType:YES]; break;
            
        case 2: [self alertMessage:systemRedpacketInstruction]; break;
            
        case 3: [self alertMessage:advertRedpacketInstruction]; break;
            
        case 4: [[RedpacketConfig sharedConfig] presentChangeViewControllerInController:self]; break;
            
        case 5: controller = [[AboutMeViewController alloc] initWithNibName:@"AboutMeViewController" bundle:[NSBundle mainBundle]]; break;
            
        default: controller = nil; break;
    }
    
    if (controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    
    [alert show];
}

- (NSArray *)functions
{
    return @[
             @"单人红包",
             @"多人红包",
             @"系统红包",
             @"广告红包",
             @"零钱页面",
             @"联系我们"
             ];
}

@end
