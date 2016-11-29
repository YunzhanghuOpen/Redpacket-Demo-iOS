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


@interface RedpacketFucListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end

@implementation RedpacketFucListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = [RedpacketUser currentUser].userInfo.userNickName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableview.delegate         = self;
    self.tableview.dataSource       = self;
    
    self.tableview.scrollEnabled    = NO;
    self.tableview.bounces          = NO;
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
    
    static NSString *systemRedpacketInstruction = @"系统红包简介：\n系统红包请联系我们：BD@yunzhanghu.com";
    static NSString *advertRedpacketInstruction = @"广告红包简介：\n广告红包请联系我们：BD@yunzhanghu.com";
    
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
